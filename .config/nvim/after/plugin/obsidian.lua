
require("obsidian").setup({
    workspaces = {
        {
            name = "main",
            path = "$HOME/repos/vaults/main",
        },
    },

    -- notes_subdir = "notes",

    dayly_notes = {
        folder = "daily",
    },

    mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
            action = function()
                return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
        },
    },

    completion = {
        prepend_note_id = true,
    },
    follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({"xdg-open", url})  -- linux
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
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
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
nmap("<leader>oo", ":ObsidianToday<CR>", "Obsidian Today")
nmap("<leader>of", ":ObsidianQuickSwitch<CR>", "Obsidian Find File")



