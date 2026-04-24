#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "=== Installing environment from $SCRIPT_DIR ==="

# =============================================================================
# 1. Symlink dotfiles (.tmux.conf, .vimrc)
# =============================================================================

for config in ".tmux.conf" ".vimrc"; do
    src="$SCRIPT_DIR/$config"
    dst="$HOME_DIR/$config"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            echo "  $config: already linked"
            continue
        fi
        mv "$dst" "${dst}.old"
        echo "  $config: backed up existing to ${config}.old"
    fi
    ln -s "$src" "$dst"
    echo "  $config: linked"
done

# =============================================================================
# 2. Neovim config
# =============================================================================

nvim_src="$SCRIPT_DIR/nvim/init.lua"
nvim_dst="$HOME_DIR/.config/nvim/init.lua"
if [ -f "$nvim_src" ]; then
    mkdir -p "$(dirname "$nvim_dst")"
    REL_NVIM="$(python3 -c "import os; print(os.path.relpath('$nvim_src', '$(dirname "$nvim_dst")'))")"
    if [ -L "$nvim_dst" ] && [ "$(readlink "$nvim_dst")" = "$REL_NVIM" ]; then
        echo "  nvim/init.lua: already linked"
    else
        [ -e "$nvim_dst" ] && mv "$nvim_dst" "${nvim_dst}.old"
        ln -s "$REL_NVIM" "$nvim_dst"
        echo "  nvim/init.lua: linked"
    fi

    old_nvim_dst="$HOME_DIR/.config/nvim/init.vim"
    old_nvim_target="../../environment/nvim/init.vim"
    if [ -L "$old_nvim_dst" ] && [ "$(readlink "$old_nvim_dst")" = "$old_nvim_target" ]; then
        rm "$old_nvim_dst"
        echo "  nvim/init.vim: removed old managed link"
    elif [ -e "$old_nvim_dst" ]; then
        mv "$old_nvim_dst" "${old_nvim_dst}.old"
        echo "  nvim/init.vim: backed up existing to init.vim.old"
    fi
fi

# =============================================================================
# 3. Ghostty config (macOS only)
# =============================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then
    ghostty_src="$SCRIPT_DIR/ghostty/config"
    ghostty_dst="$HOME_DIR/.config/ghostty/config"
    if [ -f "$ghostty_src" ]; then
        mkdir -p "$(dirname "$ghostty_dst")"
        if [ -L "$ghostty_dst" ] && [ "$(readlink "$ghostty_dst")" = "$ghostty_src" ]; then
            echo "  ghostty/config: already linked"
        else
            [ -e "$ghostty_dst" ] && mv "$ghostty_dst" "${ghostty_dst}.old"
            ln -s "$ghostty_src" "$ghostty_dst"
            echo "  ghostty/config: linked"
        fi
    fi
fi

# =============================================================================
# 4. Set up ~/.bashrc to source environment/.bashrc
# =============================================================================

SOURCE_LINE="source $SCRIPT_DIR/.bashrc"

if [ -f "$HOME_DIR/.bashrc.user" ]; then
    TARGET_RC="$HOME_DIR/.bashrc.user"
else
    TARGET_RC="$HOME_DIR/.bashrc"
fi

# Check for both absolute path and ~ version
TILDE_LINE="source ~/environment/.bashrc"
if [ -f "$TARGET_RC" ] && (grep -qF "$SOURCE_LINE" "$TARGET_RC" 2>/dev/null || grep -qF "$TILDE_LINE" "$TARGET_RC" 2>/dev/null); then
    echo "  .bashrc: source line already present"
else
    echo "$SOURCE_LINE" >> "$TARGET_RC"
    echo "  .bashrc: added source line to $TARGET_RC"
fi

# =============================================================================
# 5. Set up ~/.claude/ directory
# =============================================================================

mkdir -p "$HOME_DIR/.claude/rules"

# Skills: symlink ~/.claude/skills -> environment's .claude/skills/
# This replaces per-skill symlinks — all skills in environment/.claude/skills/ auto-propagate
SKILLS_LINK="$HOME_DIR/.claude/skills"
SKILLS_TARGET="../environment/.claude/skills"
if [ -L "$SKILLS_LINK" ] && [ "$(readlink "$SKILLS_LINK")" = "$SKILLS_TARGET" ]; then
    echo "  skills: already linked"
else
    # Clean up old per-skill symlinks or directory
    if [ -d "$SKILLS_LINK" ] && [ ! -L "$SKILLS_LINK" ]; then
        find "$SKILLS_LINK" -maxdepth 1 -type l -delete
        rmdir "$SKILLS_LINK" 2>/dev/null || true
    fi
    [ -L "$SKILLS_LINK" ] && rm "$SKILLS_LINK"
    ln -s "$SKILLS_TARGET" "$SKILLS_LINK"
    echo "  skills: linked to $SKILLS_TARGET"
fi

# =============================================================================
# 6. Generate ~/.claude/CLAUDE.md (base layer + machine context)
# =============================================================================

CLAUDE_MD="$HOME_DIR/.claude/CLAUDE.md"

# Remove old symlink if exists (migration from previous setup)
if [ -L "$CLAUDE_MD" ]; then
    rm "$CLAUDE_MD"
    echo "  CLAUDE.md: removed old symlink"
fi

# Write base layer
{
    echo "<!-- BEGIN environment/CLAUDE.md -->"
    cat "$SCRIPT_DIR/CLAUDE.md"
    echo ""
    echo "<!-- END environment/CLAUDE.md -->"
} > "$CLAUDE_MD"
echo "  CLAUDE.md: wrote base layer"

# Detect machine context
if [[ "$OSTYPE" == "darwin"* ]]; then
    MACHINE_CONTEXT="local"
    HOSTNAME_VAL="$(scutil --get LocalHostName 2>/dev/null || hostname -s)"
else
    MACHINE_CONTEXT="remote"
    HOSTNAME_VAL="$(hostname -s)"
fi

# Check known local hostnames
case "$HOSTNAME_VAL" in
    nimoca|icoca) MACHINE_CONTEXT="local" ;;
esac

{
    echo ""
    echo "<!-- BEGIN machine-context -->"
    echo "## Machine Context"
    echo ""
    echo "This machine (**${HOSTNAME_VAL}**) is a **${MACHINE_CONTEXT}** machine."
    if [ "$MACHINE_CONTEXT" = "local" ]; then
        echo "This is a macOS development laptop. Most heavy workloads (training, GPU jobs) cannot run here."
        echo "To run things on the cluster, SSH into the appropriate login node (\`ssh gb200\`, \`ssh b200\`, etc.)."
    else
        echo "This is a cluster login node. You can run commands here directly."
        echo "Use \`srun\`/\`sbatch\` for GPU workloads; the login node is for lightweight tasks, compilation, and job submission."
    fi
    echo "<!-- END machine-context -->"
} >> "$CLAUDE_MD"
echo "  CLAUDE.md: added machine context ($MACHINE_CONTEXT, $HOSTNAME_VAL)"

# =============================================================================
# 7. Symlink ~/.claude/settings.json
# =============================================================================

SETTINGS_SRC="$SCRIPT_DIR/claude_settings.json"
SETTINGS_DST="$HOME_DIR/.claude/settings.json"

if [ -f "$SETTINGS_SRC" ]; then
    REL_SETTINGS="$(python3 -c "import os; print(os.path.relpath('$SETTINGS_SRC', '$(dirname "$SETTINGS_DST")'))")"
    if [ -L "$SETTINGS_DST" ] && [ "$(readlink "$SETTINGS_DST")" = "$REL_SETTINGS" ]; then
        echo "  settings.json: already linked"
    else
        [ -e "$SETTINGS_DST" ] && mv "$SETTINGS_DST" "${SETTINGS_DST}.old"
        ln -s "$REL_SETTINGS" "$SETTINGS_DST"
        echo "  settings.json: linked"
    fi
fi

# =============================================================================
# 8. Set up ~/.codex/ directory
# =============================================================================

mkdir -p "$HOME_DIR/.codex"

CODEX_CONFIG_SRC="$SCRIPT_DIR/codex_config.toml"
CODEX_CONFIG_DST="$HOME_DIR/.codex/config.toml"

if [ -f "$CODEX_CONFIG_SRC" ]; then
    REL_CODEX_CONFIG="$(python3 -c "import os; print(os.path.relpath('$CODEX_CONFIG_SRC', '$(dirname "$CODEX_CONFIG_DST")'))")"
    if [ -L "$CODEX_CONFIG_DST" ] && [ "$(readlink "$CODEX_CONFIG_DST")" = "$REL_CODEX_CONFIG" ]; then
        echo "  codex/config.toml: already linked"
    else
        [ -e "$CODEX_CONFIG_DST" ] && mv "$CODEX_CONFIG_DST" "${CODEX_CONFIG_DST}.old"
        ln -s "$REL_CODEX_CONFIG" "$CODEX_CONFIG_DST"
        echo "  codex/config.toml: linked"
    fi
fi

CODEX_AGENTS="$HOME_DIR/.codex/AGENTS.md"

{
    echo "<!-- BEGIN environment/AGENTS.md -->"
    cat "$SCRIPT_DIR/AGENTS.md"
    echo ""
    echo "<!-- END environment/AGENTS.md -->"
    echo ""
    echo "<!-- BEGIN machine-context -->"
    echo "## Machine Context"
    echo ""
    echo "This machine (**${HOSTNAME_VAL}**) is a **${MACHINE_CONTEXT}** machine."
    if [ "$MACHINE_CONTEXT" = "local" ]; then
        echo "This is a macOS development laptop. Most heavy workloads (training, GPU jobs) cannot run here."
        echo "To run things on the cluster, SSH into the appropriate login node (\`ssh gb200\`, \`ssh b200\`, etc.)."
    else
        echo "This is a cluster login node. You can run commands here directly."
        echo "Use \`srun\`/\`sbatch\` for GPU workloads; the login node is for lightweight tasks, compilation, and job submission."
    fi
    echo "<!-- END machine-context -->"
} > "$CODEX_AGENTS"
echo "  codex/AGENTS.md: wrote base layer"

# =============================================================================
# 9. Set up global gitignore (core.excludesFile) and hooks (core.hooksPath)
# =============================================================================

# Global gitignore
GITIGNORE_SRC="$SCRIPT_DIR/gitignore_global"
if [ -f "$GITIGNORE_SRC" ]; then
    CURRENT="$(git config --global core.excludesFile 2>/dev/null || echo "")"
    if [ "$CURRENT" = "$GITIGNORE_SRC" ]; then
        echo "  core.excludesFile: already configured"
    else
        [ -n "$CURRENT" ] && echo "  WARNING: overwriting existing core.excludesFile=$CURRENT"
        git config --global core.excludesFile "$GITIGNORE_SRC"
        echo "  core.excludesFile: set -> $GITIGNORE_SRC"
    fi
fi

# Git template directory (provides post-checkout hook for new repos/clones)
TEMPLATE_SRC="$SCRIPT_DIR/git-template"
if [ -d "$TEMPLATE_SRC" ]; then
    CURRENT="$(git config --global init.templateDir 2>/dev/null || echo "")"
    if [ "$CURRENT" = "$TEMPLATE_SRC" ]; then
        echo "  init.templateDir: already configured"
    else
        [ -n "$CURRENT" ] && echo "  WARNING: overwriting existing init.templateDir=$CURRENT"
        git config --global init.templateDir "$TEMPLATE_SRC"
        echo "  init.templateDir: set -> $TEMPLATE_SRC"
    fi
fi

# Clean up old core.hooksPath if it was set by a previous install
OLD_HOOKS="$(git config --global core.hooksPath 2>/dev/null || echo "")"
if [ -n "$OLD_HOOKS" ]; then
    git config --global --unset core.hooksPath
    echo "  core.hooksPath: removed (migrated to init.templateDir)"
fi

# =============================================================================
# 10. Note about bash_profile
# =============================================================================

if [ ! -f "$HOME_DIR/.bash_profile" ]; then
    echo ""
    echo "  NOTE: No ~/.bash_profile found."
    echo "  See $SCRIPT_DIR/bash_profile.template for a reference."
fi

echo ""
echo "=== Environment installed. ==="
