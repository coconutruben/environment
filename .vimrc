" These remap the controls for moving between split panes in vim
" it only does left/right as I do not really see the point in up-down yet.
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" These are some code-formatting helpers
" set textwidth=80
set colorcolumn=80
syntax on
set number
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set autoindent
