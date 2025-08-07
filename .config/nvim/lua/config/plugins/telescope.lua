return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

		"nvim-telescope/telescope-smart-history.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"kkharji/sqlite.lua",
	},
	config = function()
	local data = assert(vim.fn.stdpath "data") --[[@as string]]
	path = vim.fs.joinpath(data, "telescope_history.sqlite3")
	extensions = {

		fzf = {},
		history = {
			path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
			limit = 100,
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown {},
		},
	},

	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "smart_history")
	pcall(require("telescope").load_extension, "ui-select")
	local builtin = require('telescope.builtin')
	vim.keymap.set("n", "<leader>.", builtin.find_files, {})
	vim.keymap.set("n", "<leader>,", builtin.oldfiles, {})
	-- vim.keymap.set("n", "<leader>," builtin.oldfiles, {})
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
	vim.keymap.set("n", "<leader>sd", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>sc", builtin.command_history, {})
	vim.keymap.set("n", "<leader>sj", builtin.jumplist, {})
	vim.keymap.set("n", "<leader>p", builtin.registers, {})
	vim.keymap.set("n", "<leader>P", builtin.pickers, {})

	vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find)
	vim.keymap.set("n", "<leader>sw", builtin.grep_string)
	vim.keymap.set("n", "<leader>sh", builtin.help_tags)
	vim.keymap.set("n", "<leader>sm", builtin.man_pages)
end
}
