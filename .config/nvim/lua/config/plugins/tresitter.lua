return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
        config = function()
            local ensure_installed = { "python", "rust", "cpp", "markdown", "markdown_inline" }
            local installed = require("nvim-treesitter.config").get_installed()
            local to_install = vim.iter(ensure_installed)
                :filter(function(p)
                    return not vim.tbl_contains(installed, p)
                end)
                :totable()
            if #to_install > 0 then
                require("nvim-treesitter").install(to_install)
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")

            local selections = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ao"] = "@conditional.outer",
                ["io"] = "@conditional.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            }
            for lhs, query in pairs(selections) do
                vim.keymap.set({ "x", "o" }, lhs, function()
                    select.select_textobject(query, "textobjects")
                end, { desc = "Select " .. query })
            end

            local next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]o"] = "@conditional.outer",
                ["]l"] = "@loop.outer",
            }
            local next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
            }
            local prev_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[o"] = "@conditional.outer",
                ["[l"] = "@loop.outer",
            }
            local prev_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
            }
            for lhs, query in pairs(next_start) do
                vim.keymap.set({ "n", "x", "o" }, lhs, function()
                    move.goto_next_start(query, "textobjects")
                end, { desc = "Next start " .. query })
            end
            for lhs, query in pairs(next_end) do
                vim.keymap.set({ "n", "x", "o" }, lhs, function()
                    move.goto_next_end(query, "textobjects")
                end, { desc = "Next end " .. query })
            end
            for lhs, query in pairs(prev_start) do
                vim.keymap.set({ "n", "x", "o" }, lhs, function()
                    move.goto_previous_start(query, "textobjects")
                end, { desc = "Prev start " .. query })
            end
            for lhs, query in pairs(prev_end) do
                vim.keymap.set({ "n", "x", "o" }, lhs, function()
                    move.goto_previous_end(query, "textobjects")
                end, { desc = "Prev end " .. query })
            end
        end,
    },
}
