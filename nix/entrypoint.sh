#!/bin/sh
set -e

# if [ -w /etc/passwd ] && [ -w /etc/group ]; then

uid="${UID:-$(id -u)}"
gid="${GID:-$(id -g)}"

# echo "$USER:x:$uid:$gid:Zix:$HOME:/bin/sh" >>/etc/passwd
# echo "$USER:x:$gid:" >>/etc/group

adduser -u "$uid" -g "$gid" nixblr >/dev/null 2>&1

# fi

exec "${@:-/bin/sh}"
