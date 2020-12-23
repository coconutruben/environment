## ssh keys

use ssh keys to ssh to something (cloud instance, github, etc) without
needing to provide a password all the time, while also ensuring that it's safe

Ideally, generate one set of keys (public, private) for each machine you have,
and just use that key for all services. That'll make management easiest.

### generation

For the steps below, first set COCOEMAIL and KEYFNAME to the appropriate values
before running the scripts.

```
ssh-keygen -t ed25519 -C "${COCOEMAIL}" -f ~/.ssh/${KEYFNAME}
```

### adding to agent and default connections

Run this to add the key to the agent. ssh-addkey is an alias here too that works
on Debian and Darwin (MacOS).

```
eval "$(ssh-agent -s)"
ssh-addkey ~/.ssh/${KEYFNAME}
```

Run this to make sure all connections attempt to use the key

Debian version
```
printf "\nHost *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/${KEYFNAME}\n" >> ~/.ssh/config
```

MacOS version

```
printf "\nHost *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/${KEYFNAME}\n" >> ~/.ssh/config
```

### adding to service

This assumes that you're using pbcopy. The .bashrc in this environment for
Debian setups up those aliases automatically to point to xclip (so you should
have that installed).

```
cat ~/.ssh/${KEYFNAME}.pub | pbcopy
```

paste into the service
