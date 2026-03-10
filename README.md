# Motivation

Pretty straight forward stuff: I change laptops frequently, VM instances, and
what have you, and this allows for a simple way to have the same environment
going in all places. Thus, this is purely for myself, and if it's helpful to
someone else I'll be delighted, that's a nice bonus.

# Quick Setup

## macOS

```bash
# 1. Install Homebrew bash (modern bash 5.x)
brew install bash
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash

# 2. Set up bash completion (including git)
brew install bash-completion@2
curl -o /opt/homebrew/etc/bash_completion.d/git-completion.bash \
     https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

# 3. Set your hostname
sudo scutil --set ComputerName "your-hostname"
sudo scutil --set LocalHostName "your-hostname"
sudo scutil --set HostName "your-hostname"

# 4. Copy/symlink config files
cp .bashrc ~/.bashrc
cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf

# 5. Make sure ~/.bash_profile sources ~/.bashrc
echo 'if [ -f ~/.bashrc ]; then source ~/.bashrc; fi' >> ~/.bash_profile
```

See [BASH.md](BASH.md) for detailed bash setup and troubleshooting.

## Linux

```bash
./linux_install.sh
```

# Expansion

It became obvious to me that I keep Googling how to do the same things:
- iterate over a list in bash
- use random unix controls properly e.g. cut
- git pull vs rebase and what --mixed does

So I decided to make myself a few cheat-cheats to make look-up simple, and
hopefully remember things better as I'm forced to write those cheet-sheets. So
they'll have general approaches on how to do certain things, and syntax lookup,
etc. Hopefully those are also helpful to some, though I'd encourage everyone to
make their own versions to experiment with things and learn the things that
pertain to their own workflow.
