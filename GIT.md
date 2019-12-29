# Overview

TODO

# Workflow

The workflow I use is inspired by the chromium.org workflow and is rebase based.
What this means is that every change is done in a branch or on master, doesn't
matter, as ultimately everything is rebased on master anyways. This preserves
all commits, doesn't add merge commits, and makes the history nice and clean.

## Impliations

- when doing git pull, make sure to do --rebase

# How-to

## multi edits on same file

You have made multiple edits on the same file, and they should be split into
multiple commits.

- `git add -i` to interactively add parts of the file to a commit

## split a commit into multiple parts

You have a large commit that's suboptimal, and you need to split it into
multiple parts

- `git rebase -i` and `edit` on the desired commit
- `git reset --mixed HEAD~` to revert to and unstage the files
- `git add -i` for the files you need and to make the commit work

Bonus: preserving the previous commit message

- `git commit --reuse-message=<commit>` or `git commit --reuse-message=HEAD@{1}`
  if you know the message is just the previous commit's one

## branch stufff

- showing branches `git branch`
- making branch point to commit `git branch -f [branch] [commit]`
- making current branch point to commit `git reset --hard [commit]`
- make branch to point to commit `git branch [name] [commit]`
