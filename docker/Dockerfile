FROM node:20 AS base

ARG CLAUDE_CODE_VERSION=latest

# Development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git bash curl openssh-client rsync vim tmux \
    python3 python3-pip less procps fzf jq gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# npm global setup
RUN mkdir -p /usr/local/share/npm-global && \
    chmod 777 /usr/local/share/npm-global
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global

# Install Claude Code via npm
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# Persist bash history across container restarts
RUN mkdir -p /commandhistory && chmod 777 /commandhistory
ENV HISTFILE=/commandhistory/.bash_history
ENV PROMPT_COMMAND="history -a"

# --- Second stage: add user matching the host ---
FROM base

ARG HOST_USER=coconutrubenbfl
ARG HOST_HOME=/Users/coconutrubenbfl
ARG HOST_UID=501
ARG HOST_GID=20

# Create group if it doesn't exist, then create user with matching UID/GID/home
RUN groupadd -g ${HOST_GID} hostgroup 2>/dev/null || true && \
    useradd -m -d ${HOST_HOME} -s /bin/bash -u ${HOST_UID} -g ${HOST_GID} ${HOST_USER}

# Create work and config directories
RUN mkdir -p ${HOST_HOME}/work ${HOST_HOME}/.claude && \
    chown -R ${HOST_USER}:${HOST_GID} ${HOST_HOME}/work ${HOST_HOME}/.claude

# Fix ownership for npm global and history
RUN chown -R ${HOST_USER}:${HOST_GID} /usr/local/share/npm-global /commandhistory

USER ${HOST_USER}
WORKDIR ${HOST_HOME}/work

ENV HOME=${HOST_HOME}
ENV PATH=${HOST_HOME}/.local/bin:${HOST_HOME}/environment/script:${HOST_HOME}/environment_bfl/script:/usr/local/share/npm-global/bin:$PATH
ENV SHELL=/bin/bash
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
ENV EDITOR=vim
ENV VISUAL=vim
