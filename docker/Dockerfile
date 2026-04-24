FROM node:20 AS base

ARG CLAUDE_CODE_VERSION=latest

# Development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git bash curl openssh-client rsync vim tmux \
    python3 python3-pip less procps fzf jq gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# npm global setup
RUN mkdir -p /usr/local/share/npm-global && \
    chmod 777 /usr/local/share/npm-global
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global

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
RUN mkdir -p ${HOST_HOME}/work ${HOST_HOME}/.claude ${HOST_HOME}/.local && \
    chown -R ${HOST_USER}:${HOST_GID} ${HOST_HOME}/work ${HOST_HOME}/.claude ${HOST_HOME}/.local

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

# =============================================================================
# Kube contexts
# =============================================================================
# Auto-discover all kubeconfigs in ~/.kube/configs/
# Added to both .bashrc and .bash_profile so it works in interactive shells
# AND in Claude Code's bash tool (which initializes from user profile)
RUN echo 'export KUBECONFIG=$(ls ~/.kube/configs/*.yaml 2>/dev/null | tr '"'"'\n'"'"' '"'"':'"'"')' | tee -a ${HOST_HOME}/.bashrc >> ${HOST_HOME}/.bash_profile

USER root
RUN cat > /usr/local/bin/claude-bootstrap.sh << 'EOF'
#!/bin/bash
set -e
if [ ! -x "$HOME/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash
  ln -sf "$HOME/.local/bin/claude" /usr/local/share/npm-global/bin/claude || true
fi
exec "$@"
EOF
RUN chmod +x /usr/local/bin/claude-bootstrap.sh
USER ${HOST_USER}

ENTRYPOINT ["/usr/local/bin/claude-bootstrap.sh"]
