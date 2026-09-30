local git = require("config.git")

return {
  -- Branch review: everything an agent committed since branching off main/master.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gM",
        function()
          local base = git.default_branch()
          if base then vim.cmd("DiffviewOpen " .. base .. "...HEAD") end
        end,
        desc = "Review branch vs [M]ain",
      },
      {
        "<leader>gH",
        function()
          local base = git.default_branch()
          if base then vim.cmd("DiffviewFileHistory --range=" .. base .. "...HEAD") end
        end,
        desc = "Branch commit [H]istory",
      },
    },
    opts = function()
      local close = { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } }
      return {
        keymaps = {
          view = { close },
          file_panel = { close },
          file_history_panel = { close },
        },
      }
    end,
  },

  -- Hunk review: stage = accepted, reset = rejected.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        local function range() return { vim.fn.line("."), vim.fn.line("v") } end

        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map("n", "<leader>gp", gs.preview_hunk_inline, "[P]review hunk")
        map("n", "<leader>ga", gs.stage_hunk, "[A]ccept (stage) hunk")
        map("n", "<leader>gr", gs.reset_hunk, "[R]eject (reset) hunk")
        map("v", "<leader>ga", function() gs.stage_hunk(range()) end, "[A]ccept (stage) lines")
        map("v", "<leader>gr", function() gs.reset_hunk(range()) end, "[R]eject (reset) lines")
        map("n", "<leader>gA", gs.stage_buffer, "[A]ccept (stage) buffer")
        map("n", "<leader>gR", gs.reset_buffer, "[R]eject (reset) buffer")
        map("n", "<leader>gD", gs.diffthis, "[D]iff file side-by-side")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "[B]lame line")

        -- Toggle sign/hunk base between the index and where the branch left main.
        map("n", "<leader>gB", function()
          if vim.g.gitsigns_branch_base then
            vim.g.gitsigns_branch_base = nil
            gs.change_base(nil, true)
            vim.notify("gitsigns base: index")
          else
            local base = git.merge_base()
            if not base then return end
            vim.g.gitsigns_branch_base = base
            gs.change_base(base, true)
            vim.notify("gitsigns base: " .. git.default_branch() .. " (" .. base:sub(1, 7) .. ")")
          end
        end, "Toggle [B]ase index/main")
      end,
    },
  },
}
