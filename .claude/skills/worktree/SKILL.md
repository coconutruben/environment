---
name: worktree
description: Create a new git worktree in ~/work/baeume/ for a project
argument-hint: [project-feature-name]
---

Create a new worktree for the given project/feature:

1. Determine the appropriate base branch (usually main/master)
2. Create worktree: `git worktree add ~/work/baeume/$ARGUMENTS <base-branch>`
3. cd into the new worktree
4. Report the path and current branch

Note: The global post-checkout hook automatically symlinks CLAUDE.local.md and .claude/
from ~/cococlaude/ if the project is configured there. No manual setup needed.
