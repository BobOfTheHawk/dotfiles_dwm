" ── General ───────────────────────────────────────────────
set nocompatible
set encoding=utf-8
set hidden
set updatetime=100

" ── Appearance ─────────────────────────────────────────────
set number
set relativenumber
set cursorline
set scrolloff=8
set signcolumn=yes
set nowrap
set termguicolors

" ── Syntax & filetype ──────────────────────────────────────
syntax on
filetype on
filetype plugin on
filetype indent on

" ── Gruvbox theme ──────────────────────────────────────────
set background=dark
colorscheme gruvbox

" ── Indentation ────────────────────────────────────────────
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set autoindent

" ── Search ─────────────────────────────────────────────────
set incsearch
set hlsearch
set ignorecase
set smartcase

" ── Splits ─────────────────────────────────────────────────
set splitbelow
set splitright

" ── No swap/backup clutter ─────────────────────────────────
set noswapfile
set nobackup
set nowritebackup

" ── Clipboard ──────────────────────────────────────────────
set clipboard=unnamedplus

" ── Better backspace ───────────────────────────────────────
set backspace=indent,eol,start

" ── Keymaps ────────────────────────────────────────────────
let mapleader = " "

" clear search highlight
nnoremap <Esc> :nohlsearch<CR>

" split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" move lines in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" keep cursor centered
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" file explorer
nnoremap <leader>e :Ex<CR>

" ── Netrw ──────────────────────────────────────────────────
let g:netrw_banner = 0
let g:netrw_liststyle = 3
