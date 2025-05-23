return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',


        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        -- { 'j-hui/fidget.nvim', opts = {} },

        -- Additional lua configuration, makes nvim stuff amazing!
    },
    config = function()
        local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end

                vim.keymap.set('n', keys, func, {
                    buffer = bufnr,
                    desc = desc
                })
            end

            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            nmap("<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")

            nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            nmap('gD', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
            nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            nmap('<leader>ss', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wf', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
        end

        require('mason').setup()
        require('mason-lspconfig').setup()

        -- vim.api.nvim_set_hl(0, '@lsp.type.function', {})
        -- -- Hide all semantic highlights
        -- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        --     vim.api.nvim_set_hl(0, group, {})
        -- end
        --
        local lspconfig = require 'lspconfig'

        local servers = {
            pylsp = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            enabled = true,
                            ignore = { 'W391', 'W503'},
                            maxLineLength = 100
                        },
                    },
                },
            },
        }

        local capabilites = vim.lsp.protocol.make_client_capabilities()

        local mason_lspconfig = require('mason-lspconfig')

        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(servers)
        })

        lspconfig.clangd.setup {
            capabilites = capabilites,
            on_attach = on_attach,
        }
        mason_lspconfig.setup_handlers {
            function(server_name)
                require('lspconfig')[server_name].setup {
                    capabilites = capabilites,
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                }
            end,
        }
    end
}
