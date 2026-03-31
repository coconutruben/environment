# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# After each command: append to history file and reload it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Avoid duplicate entries and blank lines
HISTCONTROL=ignoredups:erasedups

# check the window size after each command
shopt -s checkwinsize

# =============================================================================
# Prompt
# =============================================================================

# Color prompt: green user@host, blue dir
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='\u@\h:\W\$ '
fi
unset color_prompt

# Set xterm title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
esac

# =============================================================================
# Colors and Aliases
# =============================================================================

# Enable color support of ls and grep (Linux)
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Use vim for all editing by default
export VISUAL=vim
export EDITOR="$VISUAL"

# Make pbcopy/pbpaste work on Linux via xclip
if [[ "$OSTYPE" != "darwin"* ]]; then
    if command -v xclip &>/dev/null; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    fi
fi

# =============================================================================
# Bash Completion
# =============================================================================
# See BASH.md for full setup instructions

if ! shopt -oq posix; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS with Homebrew bash-completion@2
    export BASH_COMPLETION_COMPAT_DIR="/opt/homebrew/etc/bash_completion.d"
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
  else
    # Linux (Debian/Ubuntu)
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
fi

# =============================================================================
# PATH
# =============================================================================

[ -d "$HOME/environment/script" ] && export PATH="$HOME/environment/script:$PATH"
[ -d "$HOME/environment_bfl/script" ] && export PATH="$HOME/environment_bfl/script:$PATH"

# =============================================================================
# Kube contexts
# =============================================================================
export KUBECONFIG=$(ls ~/.kube/configs/*.yaml | tr '\n' ':')
