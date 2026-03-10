FROM node:20

ARG CLAUDE_CODE_VERSION=latest

# Development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    bash \
    curl \
    openssh-client \
    rsync \
    vim \
    tmux \
    python3 \
    python3-pip \
    less \
    procps \
    fzf \
    jq \
    gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create copus user
RUN useradd -m -s /bin/bash copus

# Persist bash history across container restarts
RUN mkdir /commandhistory && \
    touch /commandhistory/.bash_history && \
    chown -R copus:copus /commandhistory
ENV HISTFILE=/commandhistory/.bash_history
ENV PROMPT_COMMAND="history -a"

# Create work and config directories
RUN mkdir -p /home/copus/work /home/copus/.claude && \
    chown -R copus:copus /home/copus/work /home/copus/.claude

# npm global setup
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R copus:copus /usr/local/share/npm-global

USER copus
WORKDIR /home/copus/work

ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin
ENV SHELL=/bin/bash
ENV EDITOR=vim
ENV VISUAL=vim

# Install Claude Code via npm
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}
