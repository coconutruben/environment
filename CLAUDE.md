## subagents

- generously use sub-agents with Opus 4.6 for exploration and other tasks

## philosophy

- be aggressive in your development and refactoring, preferring loud and obvious failures over fallbacks, as fallbacks
  are hard to debug and work with. If I request a fallback, implement it, and if you feel strongly a sensible fallback
  might be needed, suggest it and get confirmation, but DO NOT add random fallbacks just to avoid failure and crashes
  that would obfuscate meaningful failures and crashes

## development style

- use git worktrees to develop things by leveraging ~/baeume as the default directory where to plce worktrees for
  any and all projects
  
- prefer to develop in small increments
- make every step into its own commit
- make the steps self contained
- commit with 3 sub headers ## why ## what ## testing where testing has a reproducible test after the initial short phrase summarizing

## code references and resources

- most oss code that is relevant is checked out inside of ~/oss
- if it's not there, ask for explicit permission and then git clone whatever oss code repo you need to be in there
- prefer to analyze the source code rather than fetching file by file or referring to other things

## tracking

- whenever you notice that you made a mistake or did something wrong that needed modification inside a project, edit the CLAUDE.local.md (or if it doesn't exist yet, create it) for that project, to make sure those mistakes don't happen anymore
