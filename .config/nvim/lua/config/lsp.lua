require('lspconfig') -- integrate lspconfig’s shared configs

local config_dir = vim.fn.stdpath("config") .. "/lsp"
local files = vim.fn.globpath(config_dir, "*.lua", false, true)

local servers = {}
for _, filepath in ipairs(files) do
	local name = vim.fn.fnamemodify(filepath, ":t:r")
	table.insert(servers, name)
end

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local buf = ev.buf
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
		end

		map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("n", "<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")

		local builtin = require("telescope.builtin")
		map("n", "gd", builtin.lsp_definitions, "[G]oto [D]efinition")
		map("n", "gr", builtin.lsp_references, "[G]oto [R]eferences")
		map("n", "gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
		map("n", "<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
		map("n", "<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
		map("n", "<leader>ss", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		--
		-- 			-- See `:help K` for why this keymap
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
		--
		-- 			-- Lesser used LSP functionality
		map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		map("n", "<leader>wf", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace [L]ist Folders")

		-- Diagnostics
		vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Floting diagnostics message' })
		vim.keymap.set('n', ']d', vim.diagnostic.get_prev, { desc = 'Goto prev diagnostics message' })
		vim.keymap.set('n', '[d', vim.diagnostic.get_next, { desc = 'Goto prev diagnostics message' })
	end,
})
