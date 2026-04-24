## Overview

Vim configuration lives in `~/.vimrc`, symlinked from `~/environment/.vimrc`.

Neovim uses `~/.config/nvim/init.vim`, symlinked from `~/environment/nvim/init.vim`.
That file sources `~/environment/.vimrc`, so Vim and Neovim share the same base behavior.

Current behavior:
- `<C-H>` and `<C-L>` move between horizontal split panes.
- New splits open below and to the right.
- Syntax highlighting and line numbers are enabled.
- `colorcolumn=120`.
- Tabs expand to spaces with 2-space indentation.
- `autoindent` is enabled.
