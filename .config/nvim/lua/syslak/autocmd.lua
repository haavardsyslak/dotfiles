-- autocommands

vim.api.nvim_set_keymap("i", "<A-k>", "<Esc>/(__)<Enter>\"_c4l", {noremap = true})

local mappings = {
    -- Equation stuff
    {";f", "\\frac{}{(__)} (__)<Esc>F\\f{a", {"tex", "markdown"}},
    {";eq", "\\begin{equation}<CR><CR>\\end{equation}<Esc>ki", {"tex", "markdown"}},
    {";al", "\\begin{aligned}<CR><CR>\\end{aligned}<Esc>ki", {"tex", "markdown"}},
    {";o", "\\overline{}(__)<Esc>F\\f{a", {"tex"}},
    {";d", "\\cdot", {"tex", "markdown"}},
    {";in", "\\int_{}^{(__)} (__)<Esc>F^i", {"tex", "markdown"}},
    {";su", "\\sum_{}^{(__)} (__)<Esc>F^hi", {"tex", "markdown"}},
    -- Sections
    {";s", "\\section{}<CR><CR>(__)<Esc>2k$i", {"tex"}},
    {";ss", "\\subsection{}<CR><CR>(__)<Esc>2k$i", {"tex"}},
    {";sss", "\\subsubsection{}<CR><CR>(__)<Esc>2k$i", {"tex"}},
    -- Text
    {";b", "\\textbf{}<Esc>i", {"tex"}},
    {";i", "\\textit{}<Esc>i", {"tex"}},
    {";t", "\\texttt{}<Esc>i", {"tex"}},
    {";e", "\\emph{}<Esc>i", {"tex"}},
    -- Figures, tikz
    {";ff", "\\begin{figure}<CR>" ..
    "\\centering<CR>\\includegraphics[width=\\textwidth]{(__)}<CR>" ..
    "\\caption{(__)}<CR>\\label{fig:(__)}<CR>\\end{figure}<Esc>3kf=a", {"tex"}},
    {";sf", "\\begin{figure}[h!]<CR>\\centering<CR>" ..
    "\\begin{subfigure}{0.45\\textwidth}<CR>" ..
    "\\includegraphics[width=\\textwidth]{(__)}<CR>" ..
    "\\caption{(__)}<CR>" ..
    "\\label{fig:(__)}<CR>" ..
    "\\end{subfigure}<CR>" ..
    "\\hfill<CR>" ..
    "\\begin{subfigure}{0.45\\textwidth}<CR>" ..
    "\\includegraphics[width=\\textwidth]{(__)}<CR>" ..
    "\\caption{(__)}<CR>" ..
    "\\label{fig:(__)}<CR>" ..
    "\\end{subfigure}<CR>" ..
    "\\caption{(__)}<CR>" ..
    "\\label{fig:(__)}<CR>" ..
    "\\end{figure}<Esc>12kf=a", {"tex"}},
    {";tc", "\\begin{center}<CR>\\begin{circuitikz}[american, scale=1.3]" ..
    "<CR>\\draw<CR>;<CR>\\end{circuitikz}<CR>\\end{center}<Esc>kkO", {"tex"}},
    {";cb", "\\left\\{ \\right\\}<Esc>8hi", {"tex", "markdown"}},
    -- Greek letters
    {";gO", "\\Omega", {"tex", "markdown"}},
    {";go", "\\omega", {"tex", "markdown"}},
    {";gp", "\\phi", {"tex", "markdown"}},
    {";gP", "\\Phi", {"tex", "markdown"}},
    {";gt", "\\theta", {"tex", "markdown"}},
    {";gT", "\\Theta", {"tex", "markdown"}},
    {";ga", "\\alpha", {"tex", "markdown"}},
    {";gA", "\\Alpha", {"tex", "markdown"}},
    {";gb", "\\beta", {"tex", "markdown"}},
    {";gB", "\\Beta", {"tex", "markdown"}},
    {";gl", "\\lambda", {"tex", "markdown"}},
    {";gL", "\\Lambda", {"tex", "markdown"}},

    -- Itemize
    {";it", "\\begin{itemize}<CR>\\item<CR>\\end{itemize}<Esc>k==A", {"tex"}},
    {";n", "\\footnote{}<Esc>i", {"tex"}},
    {";B", "\\mathbf{}<Esc>i", {"tex", "markdown"}},
    -- {";p", "fmt.Println()<Esc>i"},
    -- {";mi", "if __name__ == \"__main__\":<CR>"},
    -- {";mf", "if __name__ == \"__main__\":<CR>main()<CR>"},
    {";m", "\\begin{bmatrix}\\end{bmatrix}<Esc>Fehi", {"tex"}},
}
-- Set mappings for each filetype

for _, map in ipairs(mappings) do
    local keys = map[1]
    local command = map[2]
    local filetypes = map[3]
    if filetypes == nil then
        print("No filetype given for mapping" .. keys)
    else
        for _, filetype in ipairs(filetypes) do
            local autocmd = "autocmd Filetype " .. filetype .. " inoremap " .. keys .. " " .. command
            vim.api.nvim_command(autocmd)
        end
    end
end

-- for filetype, map_list in pairs(mappings) do
--   for _, map in ipairs(map_list) do
--     vim.api.nvim_command("autocmd Filetype " .. filetype .. " inoremap " .. map[1] .. " " .. map[2])
--   end
-- end
--
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.cpp', '*.hpp' },
  callback = function()
    vim.cmd('silent! !clang-format -i %')
  end,
  desc = 'Run clang-format on save for .cpp and .hpp files in the specific directory',
})
