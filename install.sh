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
# 2. Ghostty config (macOS only)
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
# 3. Set up ~/.bashrc to source environment/.bashrc
# =============================================================================

SOURCE_LINE="source $SCRIPT_DIR/.bashrc"

if [ -f "$HOME_DIR/.bashrc.user" ]; then
    TARGET_RC="$HOME_DIR/.bashrc.user"
else
    TARGET_RC="$HOME_DIR/.bashrc"
fi

if [ -f "$TARGET_RC" ] && grep -qF "$SOURCE_LINE" "$TARGET_RC" 2>/dev/null; then
    echo "  .bashrc: source line already present"
else
    echo "$SOURCE_LINE" >> "$TARGET_RC"
    echo "  .bashrc: added source line to $TARGET_RC"
fi

# =============================================================================
# 4. Set up ~/.claude/ directory
# =============================================================================

mkdir -p "$HOME_DIR/.claude/rules"
mkdir -p "$HOME_DIR/.claude/skills"

# =============================================================================
# 5. Generate ~/.claude/CLAUDE.md (base layer + machine context)
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
# 6. Symlink ~/.claude/settings.json
# =============================================================================

SETTINGS_SRC="$SCRIPT_DIR/claude_settings.json"
SETTINGS_DST="$HOME_DIR/.claude/settings.json"

if [ -f "$SETTINGS_SRC" ]; then
    if [ -L "$SETTINGS_DST" ] && [ "$(readlink "$SETTINGS_DST")" = "$SETTINGS_SRC" ]; then
        echo "  settings.json: already linked"
    else
        [ -e "$SETTINGS_DST" ] && mv "$SETTINGS_DST" "${SETTINGS_DST}.old"
        ln -s "$SETTINGS_SRC" "$SETTINGS_DST"
        echo "  settings.json: linked"
    fi
fi

# =============================================================================
# 7. Symlink skills
# =============================================================================

SKILL_DIR="$HOME_DIR/.claude/skills"
for skill in "$SCRIPT_DIR"/skills/*/; do
    [ -d "$skill" ] || continue
    skill_name=$(basename "$skill")
    target="$SKILL_DIR/$skill_name"
    [ -L "$target" ] && rm "$target"
    ln -s "$skill" "$target"
    echo "  skill: $skill_name linked"
done

# =============================================================================
# 8. Note about bash_profile
# =============================================================================

if [ ! -f "$HOME_DIR/.bash_profile" ]; then
    echo ""
    echo "  NOTE: No ~/.bash_profile found."
    echo "  See $SCRIPT_DIR/bash_profile.template for a reference."
fi

echo ""
echo "=== Environment installed. ==="
