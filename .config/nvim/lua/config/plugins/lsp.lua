return {
    'neovim/nvim-lspconfig',
	dependencies = { 'saghen/blink.cmp',
        { 'williamboman/mason.nvim' },
    --     -- Useful status updates for LSP
    --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    --     -- { 'j-hui/fidget.nvim', opts = {} },
	},
    config = function()
		require("config.lsp")
	end
}
