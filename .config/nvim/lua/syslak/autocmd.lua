-- autocommands


vim.api.nvim_set_keymap("i", "<A-k>", "<Esc>/(__)<Enter>\"_c4l", {noremap = true})

local mappings = {
  tex = {
    -- Equation stuff
    {";f", "\\frac{}{(__)} (__)<Esc>F\\f{a"},
    {";eq", "\\begin{equation}<CR><CR>\\end{equation}<CR>(__)<Esc>kki"},
    {";al", "\\begin{aligned}<CR><CR>\\end{aligned}<Esc>ki"},
    {";o", "\\overline{}(__)<Esc>F\\f{a"},
    {";d", "\\cdot"},
    --{";i", "\\int_{}^{(__)} (__)<Esc>F_la"},
    --{";s", "\\sum_{}^{(__)} (__)<Esc>F_la"},
    -- Sections
    {";s", "\\section{}<CR><CR>(__)<Esc>2k$i"},
    {";ss", "\\subsection{}<CR><CR>(__)<Esc>2k$i"},
    {";sss", "\\subsubsection{}<CR><CR>(__)<Esc>2k$i"},
    -- Text
    {";b", "\\textbf{}<Esc>i"},
    {";i", "\\textit{}<Esc>i"},
    {";t", "\\texttt{}<Esc>i"},
    {";e", "\\emph{}<Esc>i"},
    -- Figures, tikz
    {";ff", "\\begin{figure}<CR>" ..
    "\\centering<CR>\\includegraphics[width=\\textwidth]{(__)}<CR>" ..
    "\\caption{(__)}<CR>\\label{fig:(__)}<CR>\\end{figure}<Esc>3kf=a"},
    {";tc", "\\begin{center}<CR>\\begin{circuitikz}[american, scale=1.3]" ..
    "<CR>\\draw<CR>;<CR>\\end{circuitikz}<CR>\\end{center}<Esc>kkO"},
    {";cb", "\\left\\{ \\right\\}<Esc>8hi"},
    -- Greek letters
    {";gO", "\\Omega"},
    {";go", "\\omega"},
    {";gp", "\\phi"},
    {";gP", "\\Phi"},
    {";gt", "\\theta"},
    {";gT", "\\Theta"},
    -- Itemize
    {";it", "\\begin{itemize}<CR>\\item<CR>\\end{itemize}<Esc>k==A"},
    {";n", "\\footnote{}<Esc>i"},
  },
  go = {
    {";p", "fmt.Println()<Esc>i"},
  },
  python = {
    {";mi", "if __name__ == \"__main__\":<CR>"},
    {";mf", "if __name__ == \"__main__\":<CR>main()<CR>"},
  },
}

for filetype, map_list in pairs(mappings) do
  for _, map in ipairs(map_list) do
    vim.api.nvim_command("autocmd Filetype " .. filetype .. " inoremap " .. map[1] .. " " .. map[2])
  end
end
    
