" Håvard Syslak vim tudl

set nocompatible                "Use Vim settings, rather than Vi settings
                                "Be IMproved

filetype off                    "required!

" Vundle as pluginmanger

call plug#begin()

" Let vundle manage itself
"Plug 'gmarik/Vundle.vim'

"-------[ Plugins ]-------
Plug 'Valloric/YouCompleteMe'           "Autocomplete 

"Plug 'zxqfl/tabnine-vim'               " Autocomplete 

Plug 'nvie/vim-flake8'                  "Python syntax checker

Plug 'altercation/vim-colors-solarized' "Some color stuff.  

Plug 'vim-airline/vim-airline'          "Status line at the bottom

Plug 'vim-airline/vim-airline-themes' 	"status line at the bottom  

Plug 'lervag/vimtex'                    "Latex

"Plug 'vim-syntastic/syntastic'         "Syntax checker. Overridden by YMC?

Plug 'preservim/nerdcommenter'          "Does some comment stuff

"Plug 'perservim/nerdtree'              "Nerdtree

Plug 'fatih/vim-go'                     "Go syntax plug

Plug 'vimwiki/vimwiki'                  "Wimviki - Notes

Plug 'rafaqz/ranger.vim'				" Ranger vim

Plug 'jalvesaq/Nvim-R', {'branch': 'stable'} " R

"Plug 'junegunn/fzf', { 'dir': '~/syslak/fzf', 'do': './install --all' } "fzf
"Plug 'junegunn/fzf.vim'

call plug#end()                			" required! Add plugins before this line 

filetype plugin indent on       		"required!

"-------[ Non Pluginstuff from this point on ]-------

packadd! matchit                "enable matchit plug

let mapleader =","

set backspace=indent,eol,start  "allow backspacing over everything in insert mode

set history=200                  "keep 200 lines of command line history

set ruler                       "show the cursor position all the time

set showcmd                     "display incomplete commands

set incsearch                   "do incremental searching

set nu                          "show line numbers

set expandtab                   "use spaces instead of tabs

set tabstop=4                   "Set tab 'width' to 4 spaces

set softtabstop=0 "noexpandtab   "Gives you an actual tab instead of 4 spaces?

set shiftwidth=4                "set indentation to 4 spaces

set hlsearch                    "highlight search terms

set ic                          "Ignore Case during searches

set autoindent                  "start new line at the same indentation level

syntax enable                   "syntax highlighting

set cmdheight=1                 "The commandbar height

set showmatch                   "Show matching bracets when text indicator is over them

set nobackup                    " do not keep backup files, it's 70's style cluttering

" set noswapfile                "    do not write annoying intermediate swap files,
                                "    who did ever restore from swap files
                                "    anyway?
                                "    https://github.com/nvie/vimrc/blob/master/vimrc#L141

set ttimeoutlen=50              "Solves: there is a pause when leaving insert mode

set splitbelow                  " Horizontal splits open below current file

set splitright                  " Vertical splits open to the right of the current file


set nrformats-=octal            " anytime I use <C-a> to increment a number by one or <C-x> decrement a number by one
                                " vim should treat my numerals as decimals

"set wildmode=longest:list,full        " Pressing <Tab> shows command suggestions similar to pressing <Tab>
                                " in bash 
set wildmenu

" ------[ Clipboard ]-----
noremap <Leader>y "+y
noremap <Leader>p "+p

"-------[ Smart behavior ]-------

set smartcase                   " 
set smarttab
set smartindent                 " Does some indent stuff

" -------[ Autoclose stuff ]-------

inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap " ""<left>

" Mappings to traverse buffer list 
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" -------[ Some navigations stuff ]-------

nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" <F6> to open new tab
noremap <F6> <Esc>:tabnew 
noremap ø gt

" Quicker window resize
"nnoremap <A-Left> <C-w><
"nnoremap <A-Right> <C-w>>
"nnoremap <A-Up> <C-w>-
"nnoremap <A-Down> <C-w>+
nnoremap <C-A-h> <C-w><
nnoremap <C-A-l> <C-w>>
nnoremap <C-A-k> <C-w>-
nnoremap <C-A-j> <C-w>+

" Relative linenumbering
set number relativenumber
" Toggle when file is not focused
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained * set relativenumber
  autocmd BufLeave,FocusLost   * set norelativenumber
augroup END

" ------[ Enable Folding]--------

set foldmethod=indent
set foldlevel=99

" Fold using space bar  insted of za
"nnoremap <space> za

"Easy expansion of the active file directory
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Clear searches with æ
map æ :noh<return>

"Root permission on a file inside VIM
cnoremap w!! w !sudo tee >/dev/null %
" -----[ Nerdtree stuff ]-----

" Open nerdtree with ctrl + n 
map <C-n> :NERDTreeToggle<CR>
map å :vsplit 
" Have nerdtree open autimaticcaly if no filename is specified.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif 

"Replace ex mode withn gq
map Q gq

" -----[ Color stuff ]-----

highlight Pmenu ctermfg=8 ctermbg=0
highlight PmenuSel ctermfg=15 ctermbg=8
"hi LineNr   guifg=#857b6f guibg=#FFFFFF gui=none
"let g:solarized_termcolors=256
"let g:airline_powerline_fonts = 1
"let g:airline_solarized_bg='dark'

" -----[ YMC ]-----

" For C programming, allows ycm to compile the .c file and show syntax errors
" inside vim
"let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0
"Apply YCM FixIt
" <CR> or <Enter> or <Return>
" to see key notations type
" :h key-notation
map <F9> : YcmCompleter FixIt<CR>
"let g:ycm_filetype_whitelist = {'vimwiki': 1}
" ------[ Lazy fat fingers ]------

command -complete=file -bang -nargs=? Q  :q<bang> <args>
command -complete=file -bang -nargs=? W  :w<bang> <args>
command -complete=file -bang -nargs=? Wq :wq<bang> <args>

" -----[ Golang Stuff ]-----

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1


" Some syntax hightlighting stuff
if exists( 'g:loaded_operator_highlight' )
  finish
else
  let g:loaded_operator_highlight = 1
endif

if !exists( 'g:ophigh_color_gui' )
  let g:ophigh_color_gui = "cyan"
endif

if !exists( 'g:ophigh_highlight_link_group' )
  let g:ophigh_highlight_link_group = ""
endif


if !exists( 'g:ophigh_color' )
  let g:ophigh_color = "cyan"
endif

if !exists( 'g:ophigh_filetypes_to_ignore' )
  let g:ophigh_filetypes_to_ignore = {}
endif

fun! s:IgnoreFiletypeIfNotSet( file_type )
  if get( g:ophigh_filetypes_to_ignore, a:file_type, 1 )
    let g:ophigh_filetypes_to_ignore[ a:file_type ] = 1
  endif
endfunction

call s:IgnoreFiletypeIfNotSet('help')
call s:IgnoreFiletypeIfNotSet('markdown')
call s:IgnoreFiletypeIfNotSet('qf') " This is for the quickfix window
call s:IgnoreFiletypeIfNotSet('conque_term')
call s:IgnoreFiletypeIfNotSet('diff')
call s:IgnoreFiletypeIfNotSet('html')
call s:IgnoreFiletypeIfNotSet('css')
call s:IgnoreFiletypeIfNotSet('less')
call s:IgnoreFiletypeIfNotSet('xml')
call s:IgnoreFiletypeIfNotSet('sh')
call s:IgnoreFiletypeIfNotSet('bash')
call s:IgnoreFiletypeIfNotSet('notes')
call s:IgnoreFiletypeIfNotSet('jinja')

fun! s:HighlightOperators()
  if get( g:ophigh_filetypes_to_ignore, &filetype, 0 )
    return
  endif

  " for the last element of the regex, see :h /\@!
  " basically, searching for "/" is more complex since we want to avoid
  " matching against "//" or "/*" which would break C++ comment highlighting
  syntax match OperatorChars "?\|+\|-\|\*\|;\|:\|,\|<\|>\|&\||\|!\|\~\|%\|=\|)\|(\|{\|}\|\.\|\[\|\]\|/\(/\|*\)\@!"


  if g:ophigh_highlight_link_group != "" 
    exec "hi link OperatorChars " . g:ophigh_highlight_link_group
  else
    exec "hi OperatorChars guifg=" . g:ophigh_color_gui . " gui=NONE"
    exec "hi OperatorChars ctermfg=" . g:ophigh_color . " cterm=NONE"
  endif

endfunction

au Syntax * call s:HighlightOperators()
au ColorScheme * call s:HighlightOperators()


" ----- [ Vimwiki stuff ]-----
let g:vimwiki_list = [{
            \ 'auto_export': 1,
            \ 'auto_header' : 1,
            \ 'automatic_nested_syntaxes':1,
            \ 'path_html': '$HOME/uisfiles/notes/html',
            \ 'path': '$HOME/uisfiles/notes',
            \ 'template_path': '$HOME/uisfiles/notes/templates/',
            \ 'template_default':'github',
            \ 'template_ext':'.html5',
            \ 'syntax': 'markdown',
            \ 'ext':'.md',
           "\ 'custom_wiki2html': '~/go/bin/vimwiki-godown',
            \ 'custom_wiki2html': '~/programering/scripts/vimwiki/wiki2html.sh',
            \ 'autotags': 1,
            \ 'list_margin': 0,
            \ 'links_space_char' : '_',
            \}]
let g:vimwiki_folding='expr'
let g:vimwiki_hl_headers = 1
let g:vimwiki_ext2syntax = {'.md': 'markdown'}

" -----[ Vim ranger stuff ]-----
map <leader>rr :RangerEdit<cr>
map <leader>rv :RangerVSplit<cr>
map <leader>rs :RangerSplit<cr>
map <leader>rt :RangerTab<cr>
map <leader>ri :RangerInsert<cr>
map <leader>ra :RangerAppend<cr>
map <leader>rc :set operatorfunc=RangerChangeOperator<cr>g@
map <leader>rd :RangerCD<cr>
map <leader>rld :RangerLCD<cr>

"  Kem bruke piltastane uansett?
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" -----[ Vim IDE stuff from this point on]-----

" Jump to jump points <++>
inoremap <A-f> <Esc>/<++><enter>"_c4l

"-----[ Vimwiki ]-----
autocmd Filetype vimwiki inoremap ;f \frac{}{<++>} <++><Esc>F\f{a
autocmd Filetype vimwiki inoremap ;o \overline{}<++><Esc>F\f{a
autocmd Filetype vimwiki inoremap ;d \cdot 
autocmd Filetype vimwiki inoremap ;i \int\limits_{}^{<++>} <++><Esc>F_la
autocmd Filetype vimwiki inoremap ;s \sum\limits_{}^{<++>} <++><Esc>F_la
autocmd Filetype vimwiki inoremap ;b ```<CR><CR>```<Esc>ki
autocmd Filetype vimwiki inoremap ;c { \choose <++>}<++><Esc>F\hi

" -----[ LaTex ]-----
" latex preview wiht zathura
let g:vimtex_view_method = 'zathura'

autocmd Filetype tex inoremap ;f \frac{}{<++>} <++><Esc>F\f{a
autocmd Filetype tex inoremap ;o \overline{}<++><Esc>F\f{a
autocmd Filetype tex inoremap ;d \cdot 
autocmd Filetype tex inoremap ;i \int_{}^{<++>} <++><Esc>F_la
autocmd Filetype tex inoremap ;s \sum_{}^{<++>} <++><Esc>F_la
autocmd Filetype tex inoremap ;eq \begin{equation}<CR><CR>\end{equation}<CR><++><Esc>kki
autocmd Filetype tex inoremap ;al \begin{aligned}<CR><CR>\end{aligned}<Esc>ki
autocmd Filetype tex inoremap ;gO \Omega
autocmd Filetype tex inoremap ;tc \begin{center}<CR>\begin{circuitikz}[american, scale=1.3]<CR>\draw<CR>;<CR>\end{circuitikz}<CR>\end{center}<Esc>kkO

" -----[ GOLANG ]-----
autocmd Filetype go inoremap ;p fmt.Println()<Esc>i

" -----[ PYTHON ]-----
autocmd Filetype python inoremap ;mi if __name__ == "__main__":<CR>
autocmd Filetype python inoremap ;mf if __name__ == "__main__":<CR>main()<CR>

" -----[ Terminal ]-----
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen("/usr/bin/zsh", {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>
