# environment

Portable dotfiles and development environment for macOS and Linux.

## Quick Setup

```bash
git clone git@github.com:coconutruben/environment.git ~/environment
~/environment/install.sh
```

### What install.sh does

1. Symlinks `.tmux.conf`, `.vimrc` to `~/` (backs up existing)
2. Symlinks Neovim config to `~/.config/nvim/init.lua`
3. Symlinks Ghostty config (macOS only)
4. Adds `source ~/environment/.bashrc` to `~/.bashrc`
5. Sets up `~/.claude/` (CLAUDE.md, settings.json, rules, skills)
6. Sets up `~/.codex/` (config.toml symlink, generated AGENTS.md)
7. Detects local vs remote machine context

### macOS prerequisites

```bash
brew install bash bash-completion@2
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
curl -o /opt/homebrew/etc/bash_completion.d/git-completion.bash \
     https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
```

See [BASH.md](BASH.md) for detailed bash setup and hostname configuration.

## Structure

```
.bashrc                 # Shell config (macOS + Linux)
.tmux.conf              # tmux (prefix C-a, mouse, vi-mode, Tokyo Night status)
.vimrc                  # vim (2-space tabs, line numbers, split nav)
nvim/init.lua           # Neovim Lua IDE entrypoint
ghostty/config          # Ghostty terminal (macOS only, Tokyo Night)
bash_profile.template   # Reference template for ~/.bash_profile
install.sh              # Cross-platform installer
AGENTS.md               # Shared agent preferences (base layer)
CLAUDE.md               # Claude Code shim importing AGENTS.md
claude_settings.json    # Claude Code permissions
codex_config.toml       # Codex CLI defaults
docker/Dockerfile       # Docker image for autonomous Claude Code
script/                 # Scripts added to PATH
  claude-container      # Run Claude Code in Docker with skip-permissions
  codex-code            # Run host Codex with BFL overlay available
skills/                 # Claude Code slash commands
  worktree/             # /worktree — create git worktrees
  sync/                 # /sync — rsync worktree to cluster
```

## Layering with environment_bfl

This repo is the base layer. [environment_bfl](https://github.com/coconutruben/environment_bfl) (private) adds BFL-specific overlay:
- SSH config for cluster login nodes
- BFL scripts (sync_worktree, fetch_gb200)
- Project-specific Claude Code rules and skills

Run `environment/install.sh` first, then `environment_bfl/install.sh`.

## Cheat sheets

- [BASH.md](BASH.md) — Bash setup, completion, hostname
- [GIT.md](GIT.md) — Git workflow (rebase-based)
- [SSH.md](SSH.md) — SSH key setup
- [REMOTE.md](REMOTE.md) — Headless remote desktop
