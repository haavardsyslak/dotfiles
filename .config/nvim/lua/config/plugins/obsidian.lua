return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = false,
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

	},
	config = function()
		local home = ""
		if vim.fn.has("wsl") == 1 then
			home = "/mnt/c/Users/haava/Documents"
		else
			home = os.getenv("HOME")
		end

		local vault_dir = home .. "/vault"
		if vim.uv.fs_stat(vault_dir) == nil then
			return
		end

		require("obsidian").setup({
			workspaces = {
				{
					name = "vault",
					path = vault_dir,
				},
			},

			dayly_notes = {
				folder = "daily",
			},
			ui = {
				enable = false
			},

			wiki_link_func = function(opts)
				if opts.id == nil then
					return string.format("[[%s]]", opts.label)
				elseif opts.label ~= opts.id then
					return string.format("[[%s|%s]]", opts.id, opts.label)
				else
					return string.format("[[%s]]", opts.id)
				end
			end,
			-- completion = {
			--     prepend_note_id = true,
			-- },
			follow_url_func = function(url)
				-- Open the URL in the default web browser.
				vim.fn.jobstart({ "xdg-open", url }) -- linux
			end,

			-- Optional, customize how names/IDs for new notes are created.
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					print("suffix" .. suffix)
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end

				if not suffix:match("%.md") then
					suffix = suffix .. ".md"
				end

				return suffix
			end,
		})

		local nmap = function(keys, func, desc)
			if desc then
				desc = 'LSP: ' .. desc
			end

			vim.keymap.set('n', keys, func, {
				buffer = bufnr,
				desc = desc
			})
		end

		nmap("<leader>os", ":ObsidianSearch<CR>", "[O]bsidian[s]earch")
		nmap("<leader>orn", ":ObsidianRename<CR>", "[O]bsidian[r]ename")
		nmap("<leader>ov", ":ObsidianWorkspace<CR>", "Change obsidian workspace")
		nmap("<leader>od", ":ObsidianToday<CR>", "Obsidian Today")
		nmap("<leader>of", ":ObsidianQuickSwitch<CR>", "Obsidian Find File")
	end
}

