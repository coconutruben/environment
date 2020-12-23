# Notes on headless remote desktop

## Google Chrome Remote Desktop

This summarizes the guide for chrome remote desktop [here][chrome-remote]. In
summary, you need the chrome remote program in addition to an `X window system`:
here we will use `xfce`

### xfce setup

```
sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base
# default xfce screen locker doesn't work on chrome remote - overwrite
sudo apt install --assume-yes xscreensaver
# disable the display service 
sudo systemctl disable lightdm.service
# uncomment this to get some basic useful apps (firefox, etc)
# sudo apt install --assume-yes task-xfce-desktop
```

### chrome remote setup

This will by default log you out at the end to make the usermod stick
```
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg --install chrome-remote-desktop_current_amd64.deb
sudo apt install --assume-yes --fix-broken
sudo usermod -a -G chrome-remote-desktop $USER
logout
```

make remote desktop use xfce
```
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" >
/etc/chrome-remote-desktop-session'
```

install chrome (if needed)
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes --fix-broken

```

### usage

1. go to `https://remotedesktop.google.com/headless`
2. setup a computer and copy/paste the command for Debian
3. type the command on the vm instance shell/tmux
4. go to `https://remotedesktop.google.com/access` and connect

[chrome-remote]: https://cloud.google.com/solutions/chrome-desktop-remote-on-compute-engine
