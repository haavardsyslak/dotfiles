-- Git helpers shared by plugin specs.
local M = {}

local function git(args)
  local out = vim.fn.systemlist(vim.list_extend({ "git" }, args))
  if vim.v.shell_error ~= 0 then return nil end
  return out[1]
end

--- Default branch of the current repo: local main, then master, then origin/HEAD.
function M.default_branch()
  for _, b in ipairs({ "main", "master" }) do
    if git({ "rev-parse", "--verify", "--quiet", "refs/heads/" .. b }) then return b end
  end
  local remote = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
  if remote then return remote end
  vim.notify("No main/master branch found", vim.log.levels.WARN)
end

--- Commit where HEAD branched off the default branch.
function M.merge_base()
  local base = M.default_branch()
  return base and git({ "merge-base", base, "HEAD" })
end

return M
