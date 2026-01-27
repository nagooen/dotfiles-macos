" ~/.vimrc - Vim configuration

" Basic settings
set nocompatible              " Use Vim settings, rather than Vi
syntax on                     " Enable syntax highlighting
filetype plugin indent on     " Enable file type detection

" UI settings
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set showcmd                   " Show command in bottom bar
set cursorline                " Highlight current line
set wildmenu                  " Visual autocomplete for command menu
set showmatch                 " Highlight matching brackets
set ruler                     " Show line and column number

" Search settings
set incsearch                 " Search as characters are entered
set hlsearch                  " Highlight search matches
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive if uppercase present

" Tab and indent settings
set tabstop=4                 " Number of visual spaces per TAB
set softtabstop=4             " Number of spaces in tab when editing
set shiftwidth=4              " Number of spaces for auto-indent
set expandtab                 " Convert tabs to spaces
set autoindent                " Copy indent from current line
set smartindent               " Smart auto-indenting

" Performance
set lazyredraw                " Don't redraw while executing macros

" Backup and swap
set nobackup                  " Don't create backup files
set noswapfile                " Don't create swap files
set nowritebackup             " Don't create backup before overwriting

" Other settings
set encoding=utf-8            " Use UTF-8 encoding
set backspace=indent,eol,start " Allow backspace over everything
set history=1000              " Remember more commands
set scrolloff=8               " Keep 8 lines above/below cursor
set mouse=a                   " Enable mouse support

" Status line
set laststatus=2              " Always show status line
set statusline=%F%m%r%h%w\ [%l/%L,%c]\ [%p%%]

" Color scheme (uncomment if you have one installed)
" colorscheme desert

" Key mappings
" Clear search highlighting with Esc
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" File type specific settings
autocmd FileType javascript,typescript,json,yaml,html,css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
