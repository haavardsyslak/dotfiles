-- Bridge between Neovim and Pi running in another tmux pane.
-- Context uses tmux load-buffer + paste-buffer (bracketed paste), so multiline
-- payloads reach Pi's prompt without accidental early submission.

local M = {}

M.opts = {
  target = nil,        -- explicit tmux target ("project:1.1"), nil = auto
  match = "pi",        -- matched against pane command / window name / title
  submit = true,       -- press Enter after pasting
  submit_delay = 120,  -- ms between paste and Enter
  focus_on_send = false,
}

local cached_target = nil

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "pi" })
end

local function tmux(args, opts)
  opts = opts or {}
  local cmd = vim.list_extend({ "tmux" }, args)
  local res = vim.system(cmd, { text = true, stdin = opts.stdin }):wait()
  if res.code ~= 0 then
    if not opts.quiet then
      notify(("tmux %s: %s"):format(table.concat(args, " "), res.stderr or ""), vim.log.levels.ERROR)
    end
    return nil
  end
  return (res.stdout or ""):gsub("%s+$", "")
end

local function in_tmux()
  if vim.env.TMUX then return true end
  notify("not inside tmux", vim.log.levels.ERROR)
  return false
end

---@return table[] list of { id, ref, session, window, cmd, title }
local function list_panes()
  local out = tmux({ "list-panes", "-a", "-F",
    "#{pane_id}\t#{session_name}\t#{window_index}\t#{pane_index}\t#{window_name}\t#{pane_current_command}\t#{pane_title}" })
  if not out or out == "" then return {} end
  local panes = {}
  for line in vim.gsplit(out, "\n") do
    local f = vim.split(line, "\t", { plain = true })
    if #f >= 7 then
      table.insert(panes, {
        id = f[1],
        session = f[2],
        ref = ("%s:%s.%s"):format(f[2], f[3], f[4]),
        window = f[5],
        cmd = f[6],
        title = f[7],
      })
    end
  end
  return panes
end

--- 0 = no match. Running the process beats merely being named after it.
local function pi_score(p)
  local pat = M.opts.match:lower()
  if p.cmd:lower():find(pat, 1, true) then return 3 end
  if p.title:lower():find(pat, 1, true) then return 2 end
  if p.window:lower():find(pat, 1, true) then return 1 end
  return 0
end

function M.target()
  if M.opts.target then return M.opts.target end

  local panes = list_panes()
  local self_id = vim.env.TMUX_PANE
  local self_pane
  for _, p in ipairs(panes) do
    if p.id == self_id then self_pane = p end
  end

  if cached_target then
    for _, p in ipairs(panes) do
      if p.ref == cached_target or p.id == cached_target then return cached_target end
    end
    cached_target = nil
  end

  -- Best Pi-looking pane; strongly prefer current tmux session.
  local best, best_score = nil, 0
  for _, p in ipairs(panes) do
    if p.id ~= self_id then
      local score = pi_score(p)
      if score > 0 then
        if self_pane and p.session == self_pane.session then score = score + 10 end
        if score > best_score then best, best_score = p, score end
      end
    end
  end
  if best then
    cached_target = best.ref
    return cached_target
  end

  -- fallback: next window of the current session
  if self_pane then
    local wins = {}
    for _, p in ipairs(panes) do
      if p.session == self_pane.session then wins[p.ref:match("^[^:]+:(%d+)")] = true end
    end
    if vim.tbl_count(wins) > 1 then return self_pane.session .. ":+" end
  end

  notify("no Pi pane found; set vim.g.pi_tmux.target or use <leader>aw", vim.log.levels.WARN)
  return nil
end

function M.pick_target()
  if not in_tmux() then return end
  local panes = vim.tbl_filter(function(p) return p.id ~= vim.env.TMUX_PANE end, list_panes())
  if #panes == 0 then return notify("no other tmux panes", vim.log.levels.WARN) end
  vim.ui.select(panes, {
    prompt = "Pi pane",
    format_item = function(p) return ("%-16s %-12s %s"):format(p.ref, p.cmd, p.window) end,
  }, function(choice)
    if not choice then return end
    cached_target = choice.ref
    notify("Pi target: " .. choice.ref)
  end)
end

function M.focus()
  local t = M.target()
  if not t then return end
  local session = t:match("^([^:]+):")
  if session then tmux({ "switch-client", "-t", session }, { quiet = true }) end
  tmux({ "select-window", "-t", t })
  tmux({ "select-pane", "-t", t }, { quiet = true })
end

--- Paste text into the Pi pane.
---@param text string
---@param opts? { submit?: boolean, focus?: boolean }
function M.send(text, opts)
  opts = opts or {}
  if not text or text == "" then return end
  if not in_tmux() then return end
  local t = M.target()
  if not t then return end

  if not tmux({ "load-buffer", "-b", "nvim-pi", "-" }, { stdin = text }) then return end
  if not tmux({ "paste-buffer", "-b", "nvim-pi", "-d", "-p", "-t", t }) then return end

  local submit = opts.submit
  if submit == nil then submit = M.opts.submit end
  if submit then
    vim.defer_fn(function() tmux({ "send-keys", "-t", t, "Enter" }) end, M.opts.submit_delay)
  end

  local focus = opts.focus
  if focus == nil then focus = M.opts.focus_on_send end
  if focus then vim.defer_fn(M.focus, M.opts.submit_delay + 30) end
end

--- Send a raw key to the Pi pane (e.g. "Escape" to interrupt it).
function M.key(key)
  if not in_tmux() then return end
  local t = M.target()
  if t then tmux({ "send-keys", "-t", t, key }) end
end

-- ── context builders ────────────────────────────────────────────────────────

local function path(buf)
  local name = vim.api.nvim_buf_get_name(buf or 0)
  if name == "" then return nil end
  return vim.fn.fnamemodify(name, ":.")
end

local function mention(p)
  if not p then return nil end
  return p:find("%s") and ("`" .. p .. "`") or ("@" .. p)
end

--- Line range of the current visual selection. Call while still in visual mode.
local function vrange()
  local a, b = vim.fn.getpos("v"), vim.fn.getpos(".")
  local sl, el = a[2], b[2]
  if sl > el then sl, el = el, sl end
  return sl, el
end

local function vtext()
  local ok, lines = pcall(vim.fn.getregion, vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  if not ok then return nil end
  return table.concat(lines, "\n")
end

local function leave_visual()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

local function fence(body, ft)
  return ("```%s\n%s\n```"):format(ft or vim.bo.filetype, body)
end

--- Context reference: "@lua/config/lazy.lua lines 10-24"
function M.ref(sl, el)
  local p = path()
  if not p then return nil end
  if not sl then return mention(p) end
  if sl == el then return ("%s line %d"):format(mention(p), sl) end
  return ("%s lines %d-%d"):format(mention(p), sl, el)
end

local function diagnostics(bufnr, lo, hi)
  local p = path(bufnr) or "[buffer]"
  local out = {}
  for _, d in ipairs(vim.diagnostic.get(bufnr)) do
    local ln = d.lnum + 1
    if not lo or (ln >= lo and ln <= hi) then
      table.insert(out, ("%s:%d:%d: %s: %s%s"):format(
        p, ln, d.col + 1,
        vim.diagnostic.severity[d.severity],
        (d.message or ""):gsub("\n", " "),
        d.source and (" [" .. d.source .. "]") or ""))
    end
  end
  return out
end

-- ── actions ─────────────────────────────────────────────────────────────────

function M.send_buffer()
  local r = M.ref()
  if r then M.send(r, { submit = false }) end
end

function M.send_line()
  local r = M.ref(vim.fn.line("."))
  if r then M.send(r, { submit = false }) end
end

--- literal=false: send a "file lines a-b" reference. literal=true: paste the code.
function M.send_selection(literal)
  local sl, el = vrange()
  local body = literal and vtext() or nil
  leave_visual()
  if literal then
    M.send(("%s\n%s"):format(M.ref(sl, el) or "", fence(body)), { submit = false })
  else
    M.send(M.ref(sl, el), { submit = false })
  end
end

function M.send_diagnostics(scope)
  local lo, hi
  if scope == "line" then
    lo = vim.fn.line("."); hi = lo
  elseif scope == "selection" then
    lo, hi = vrange(); leave_visual()
  end
  local ds = diagnostics(0, lo, hi)
  if #ds == 0 then return notify("no diagnostics", vim.log.levels.WARN) end
  M.send(("Diagnostics:\n%s"):format(table.concat(ds, "\n")), { submit = false })
end

function M.send_quickfix()
  local items = vim.fn.getqflist()
  if #items == 0 then return notify("quickfix empty", vim.log.levels.WARN) end
  local lines = {}
  for _, it in ipairs(items) do
    local p = it.bufnr > 0 and vim.fn.fnamemodify(vim.api.nvim_buf_get_name(it.bufnr), ":.") or ""
    table.insert(lines, ("%s:%d:%d: %s"):format(p, it.lnum, it.col, (it.text or ""):gsub("^%s+", "")))
  end
  M.send(("Quickfix list:\n%s"):format(table.concat(lines, "\n")), { submit = false })
end

function M.send_yank()
  local body = vim.fn.getreg('"')
  if body == "" then return notify("empty yank register", vim.log.levels.WARN) end
  M.send(fence(body), { submit = false })
end

--- Prompt for a question, prepend it to `context` (may be nil), send + submit.
function M.ask(context, prompt)
  vim.ui.input({ prompt = prompt or "Pi: " }, function(input)
    if not input or input == "" then return end
    M.send(context and (input .. "\n\n" .. context) or input, { submit = true })
  end)
end

function M.ask_buffer() M.ask(M.ref()) end

function M.ask_line() M.ask(M.ref(vim.fn.line("."))) end

function M.ask_selection(literal)
  local sl, el = vrange()
  local body = literal and vtext() or nil
  leave_visual()
  local ctx = M.ref(sl, el)
  if literal then ctx = ("%s\n%s"):format(ctx or "", fence(body)) end
  M.ask(ctx)
end

function M.setup(opts)
  M.opts = vim.tbl_extend("force", M.opts, opts or {})
end

-- ── wiring ──────────────────────────────────────────────────────────────────

M.setup(vim.g.pi_tmux)

vim.o.autoread = true
local grp = vim.api.nvim_create_augroup("pi_tmux", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
  group = grp,
  desc = "reload buffers edited by Pi",
  callback = function()
    if vim.bo.buftype == "" then vim.cmd.checktime() end
  end,
})

vim.api.nvim_create_user_command("Pi", function(a)
  if a.args ~= "" then M.send(a.args, { submit = true }) else M.ask() end
end, { nargs = "*", desc = "Send text to Pi" })

vim.api.nvim_create_user_command("PiSend", function(a)
  M.send(M.ref(a.line1, a.line2), { submit = false })
end, { range = true, desc = "Send range reference to Pi" })

vim.api.nvim_create_user_command("PiTarget", M.pick_target, { desc = "Pick Pi tmux pane" })

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- ask (prompt + context, submits)
map("n", "<leader>aa", M.ask_buffer, "Ask Pi about buffer")
map("x", "<leader>aa", function() M.ask_selection(false) end, "Ask Pi about selection")
map("x", "<leader>aA", function() M.ask_selection(true) end, "Ask Pi (paste selection)")
map("n", "<leader>al", M.ask_line, "Ask Pi about current line")
map("n", "<leader>ap", function() M.ask(nil, "Pi (no context): ") end, "Prompt Pi")

-- Push context without submitting, then continue typing in Pi.
map("n", "<leader>ab", M.send_buffer, "Add buffer to Pi")
map("x", "<leader>as", function() M.send_selection(false) end, "Add selection range to Pi")
map("x", "<leader>aS", function() M.send_selection(true) end, "Paste selection into Pi")
map("n", "<leader>aL", M.send_line, "Add current line to Pi")
map("n", "<leader>ay", M.send_yank, "Paste yank register into Pi")

-- diagnostics / lists
map("n", "<leader>ad", function() M.send_diagnostics("line") end, "Send line diagnostics")
map("n", "<leader>aD", function() M.send_diagnostics() end, "Send buffer diagnostics")
map("x", "<leader>ad", function() M.send_diagnostics("selection") end, "Send selection diagnostics")
map("n", "<leader>aq", M.send_quickfix, "Send quickfix list")

-- control
map({ "n", "x" }, "<leader>a.", M.focus, "Focus Pi pane")
map("n", "<leader>aw", M.pick_target, "Pick Pi tmux pane")
map("n", "<leader>ax", function() M.key("Escape") end, "Interrupt Pi")
map("n", "<leader>ac", function() M.key("C-c") end, "Send Ctrl-C to Pi")
map("n", "<leader>ae", function() vim.cmd.checktime() end, "Reload files changed by Pi")

return M
