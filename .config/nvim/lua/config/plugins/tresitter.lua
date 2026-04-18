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
            local ensure_installed = { "python", "rust", "cpp" }
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
}
