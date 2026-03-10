# Bash Setup & Tips

## macOS Setup

### Installing Homebrew Bash (Bash 5)

macOS ships with an outdated bash (3.x). Install a modern version:

```bash
# Install Homebrew bash
brew install bash

# Add to allowed shells
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells

# Set as default login shell
chsh -s /opt/homebrew/bin/bash

# Verify
echo $BASH_VERSION  # Should show 5.x
```

### Bash Completion Setup

Git and other tools won't autocomplete by default. Here's how to fix it:

```bash
# 1. Install bash-completion@2 (for bash 4.1+)
brew install bash-completion@2

# 2. Git completion is NOT included - install it manually:
curl -o /opt/homebrew/etc/bash_completion.d/git-completion.bash \
     https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

# 3. Add to your ~/.bash_profile (not just ~/.bashrc!):
export BASH_COMPLETION_COMPAT_DIR="/opt/homebrew/etc/bash_completion.d"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# 4. Make sure ~/.bash_profile sources ~/.bashrc:
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
```

**Important:** Use hardcoded paths (`/opt/homebrew/...`) instead of `$(brew --prefix)` to avoid issues when PATH isn't set yet during shell startup.

### Verify Completion is Working

```bash
# Start a fresh shell
exec bash

# Test git completion
type _git 2>/dev/null && echo "Git completion loaded!" || echo "Git completion NOT loaded"

# Try it: type "git ch" and press Tab
```

### Changing Hostname

macOS has three different "names" you may want to change:

```bash
# Set all three at once (replace "your-hostname" with desired name)
sudo scutil --set ComputerName "your-hostname"    # Friendly name (Finder/Sharing)
sudo scutil --set LocalHostName "your-hostname"   # Bonjour name (.local address)
sudo scutil --set HostName "your-hostname"        # Terminal prompt hostname

# Verify
scutil --get ComputerName
scutil --get LocalHostName
scutil --get HostName

# Restart terminal or run: exec bash
```

---

## General Bash Tips

### Renaming files, even when they have spaces etc

[IFS][0] can be used here to temporarily remove spaces and set it to some place
holder, and then do the manipulation. So for example, this snippet can be used
to list all files with spaces.

```bash
OIFS="$IFS"
IFS=$'\n'
for f in `find . -type f -name "18.06*  *"`; do echo $f; done
IFS="$OIFS"
```

Notice how here the pattern is "18.0\*  \*" but it could be anything. The new
delimiter is chosen to be newline, though that can also be changed.

Lastly, the task here is echo, just a place-holder for the actual task you want
to accomplish.

[0]: https://mywiki.wooledge.org/IFS

### Login vs Interactive Shells

Understanding when config files are read:

| Shell Type | Files Read |
|------------|------------|
| Login shell (new terminal) | `~/.bash_profile` → `~/.bash_login` → `~/.profile` |
| Interactive non-login (`exec bash`) | `~/.bashrc` |

**Best practice:** Have `~/.bash_profile` source `~/.bashrc` so your config works in both cases.
