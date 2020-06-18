## Overview


# Renaming files, even when they have spaces etc

[IFS][0] can be used here to temporarily remove spaces and set it to some place
holder, and then do the manipulation. So for example, this snippet can be used
to list all files with spaces.

```
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
