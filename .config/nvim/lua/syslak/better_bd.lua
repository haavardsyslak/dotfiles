local function better_bd()
    local current_buf = vim.api.nvim_get_current_buf()
    local buffers = vim.api.nvim_list_bufs()
    local next_buf = nil

    -- Function to check if a buffer is in any window


    local function is_buffer_in_window(buf)
        for _, win in ipairs(vim.api.nvim_list_wins()) do 
            if vim.api.nvim_win_get_buf(win) == buf then
                return true
            end
        end
        return false 
    end

    -- Find the next buffer that is not in any window
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf and not is_buffer_in_window(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
            next_buf = buf
            break
        end
    end

    if next_buf then
        -- Switch to the next buffer and delete the current buffer
        vim.cmd('buffer ' .. next_buf)
        vim.cmd('bd ' .. current_buf)
    else
        -- Force close if no next buffer is available
        vim.cmd('bd!')
    end
end

-- Create the custom Vim command
vim.api.nvim_create_user_command("Betterbd", better_bd, {})
