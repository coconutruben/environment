FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    git bash curl openssh-client rsync vim tmux \
    python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code natively (standalone binary, auto-updates)
# WORKDIR /tmp is critical — prevents installer from scanning entire fs
WORKDIR /tmp
RUN curl -fsSL https://claude.ai/install.sh | bash

# Match host user UID/GID for file permissions on mounts
ARG USER_ID=501
ARG GROUP_ID=20
RUN groupadd -g $GROUP_ID hostgroup 2>/dev/null || true && \
    useradd -m -u $USER_ID -g $GROUP_ID claude
USER claude
WORKDIR /home/claude
ENV PATH="/home/claude/.local/bin:$PATH"
