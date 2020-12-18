#!/bin/bash

dir=$(dirname $(readlink -f "$0"))
home=$(readlink -f ~)
# Make a symbolic link to tmux config

for config in ".tmux.conf" ".vimrc"; do
  src="${dir}/${config}"
  dst="${home}/${config}"
  if [ -a $dst ]; then
    mv "${dst}" "${dst}.old"
  fi
  # now, setup the link in peace
  ln -s $src $dst
done
# Expand existing bashrc if it's there to have this sourced, otherwise create it
