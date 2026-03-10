---
name: sync
description: Sync a worktree to the remote cluster via rsync
argument-hint: [worktree-name remote-alias]
---

Run `sync_worktree $ARGUMENTS` to rsync the specified worktree to the remote cluster.
Show the rsync output and report success/failure.

If no arguments provided, list available worktrees in ~/work/baeume/ and ask which to sync.
