# Motivation

Pretty straight forward stuff: I change laptops frequently, VM instances, and
what have you, and this allows for a simple way to have the same environment
going in all places. Thus, this is purely for myself, and if it's helpful to
someone else I'll be delighted, that's a nice bonus.

A note on that however, speficially for tmux: if you find yourself in a nested
environment e.g. you run tmux to ssh to multiple cloud vm instances, and in
those you are running tmux as well (for example, because you don't want code to
die after you lose the connection), then don't remap Ctrl-B to Ctrl-A, otherwise
the capture gets confused. Stick with Ctrl-B for the VMs/nested things.

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
