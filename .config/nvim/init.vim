source $HOME/.config/nvim/autocmd.vim

call plug#begin()

Plug 'vim-airline/vim-airline'          "Status line at the bottom

Plug 'lervag/vimtex'                    "Latex

Plug 'Valloric/YouCompleteMe'           "Autocomplete 

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' 	" fuzzy buffers

Plug 'tomasr/molokai'
Plug 'https://gitlab.com/Syslak/nvimcolour.git'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
Plug 'norcalli/nvim-colorizer.lua'
call plug#end()

let mapleader =" "
let g:vimtex_view_method = 'zathura'
set termguicolors
colorscheme syslak
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>Y "+Y
noremap <Leader>P "+P
lua require'colorizer'.setup()

" Sets
set tabstop=4 softtabstop=4 shiftwidth=4
set expandtab
set smartindent
set hidden
set nu
set number relativenumber
set smartcase

" -------[ Autoclose stuff ]-------
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap " ""<left>

" -------[ Some navigations stuff ]-------
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k

nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>wd :close<CR>
nnoremap <Leader>wv :vsplit
nnoremap <Leader>wv :split

" Quicer window resize
nnoremap <C-A-h> <C-w><
nnoremap <C-A-l> <C-w>>
nnoremap <C-A-k> <C-w>-
nnoremap <C-A-j> <C-w>+

" Clear searches with æ
map æ :noh<return> 

nnoremap <silent> Q <nop> 

" Lazy Fat fingers
command -complete=file -bang -nargs=? Q  :q<bang> <args>
command -complete=file -bang -nargs=? W  :w<bang> <args>
command -complete=file -bang -nargs=? Wq :wq<bang> <args>

"  Kem bruke piltastane uansett?
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Find files using Telescope command-line sugar.
nnoremap <leader><Leader> <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>bb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

inoremap <A-f> <Esc>/<++><enter>"_c4l
