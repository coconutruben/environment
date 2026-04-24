## Overview

Vim configuration lives in `~/.vimrc`, symlinked from `~/environment/.vimrc`.

Neovim uses `~/.config/nvim/init.lua`, symlinked from `~/environment/nvim/init.lua`.
That file sources `~/environment/.vimrc`, so Vim and Neovim share the same base behavior before loading the Neovim IDE layer.

Current behavior:
- `<C-H>` and `<C-L>` move between horizontal split panes.
- New splits open below and to the right.
- Syntax highlighting and line numbers are enabled.
- `colorcolumn=120`.
- Tabs expand to spaces with 2-space indentation.
- `autoindent` is enabled.

Neovim additions:
- `Space` is the leader key. Press `Space` in normal mode to see available mappings.
- `<leader>ff` finds files, `<leader>fg` greps, `<leader>fb` switches buffers.
- `gd`, `gr`, `K`, `<leader>rn`, and `<leader>ca` come from LSP when a server is attached.
- `blink.cmp` provides fast LSP/path/buffer/snippet completion.
- `<A-y>` manually asks Minuet for an OpenAI-backed completion suggestion.
- `<leader>aa`, `<leader>ac`, and `<leader>ai` open CodeCompanion actions, chat, and inline edits.
- `<leader>cf` formats the current buffer manually when a formatter is available.
- Mason manages LSP servers plus Ruff, Prettier, and Stylua.
