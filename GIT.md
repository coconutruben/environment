# Overview

***Note***: *This is all based on my current understand of git. If there are
flaws and you're so inclined, please email me some reference so I can fix my
understanding*

A git repository is essentially a graph of commits. Each commit is a set of
diffs to files in the repository. That way, when you follow the graph, you can
rebuild the current directory or quickly change to a different working
directory.
The important points here are:
- each commit has one parent, but can have multiple children (branches, etc)
- each branch just points to one HEAD commit, that defines what the current
  state of the working directory is

The important concept to remember here is reachability. As every commit only has
one parents, as long as one commit in the chain is reachable, the changes can be
used again, checkedout, etc. Reachable means a branch or a tag points to that
commit. That's it. If a commit is abandoned (e.g. branch deleted) eventually
it'll be garbage collected. So make branches/tags for commits you want to keep
around.

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

## reflog

You can use git reflog to see the logs of reference changes (HEAD changes,
rebases finishing, etc). It can be useful to literally go back in time and fix a
botched rebase, as you can recover the state pre-rebase, and try again.
