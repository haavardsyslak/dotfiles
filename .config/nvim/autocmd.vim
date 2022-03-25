" -----[ LaTeX]------
autocmd Filetype tex inoremap ;f \frac{}{<++>} <++><Esc>F\f{a
autocmd Filetype tex inoremap ;o \overline{}<++><Esc>F\f{a
autocmd Filetype tex inoremap ;d \cdot 
autocmd Filetype tex inoremap ;i \int_{}^{<++>} <++><Esc>F_la
autocmd Filetype tex inoremap ;s \sum_{}^{<++>} <++><Esc>F_la
autocmd Filetype tex inoremap ;eq \begin{equation}<CR><CR>\end{equation}<CR><++><Esc>kki
autocmd Filetype tex inoremap ;al \begin{aligned}<CR><CR>\end{aligned}<Esc>ki
autocmd Filetype tex inoremap ;gO \Omega
autocmd Filetype tex inoremap ;go \omega
autocmd Filetype tex inoremap ;tc \begin{center}<CR>\begin{circuitikz}[american, scale=1.3]<CR>\draw<CR>;<CR>\end{circuitikz}<CR>\end{center}<Esc>kkO
autocmd Filetype tex inoremap ;cb \left\{ \right\}<Esc>8hi


" -----[ GOLANG ]-----
autocmd Filetype go inoremap ;p fmt.Println()<Esc>i

" -----[ PYTHON ]-----
autocmd Filetype python inoremap ;mi if __name__ == "__main__":<CR>
autocmd Filetype python inoremap ;mf if __name__ == "__main__":<CR>main()<CR>
