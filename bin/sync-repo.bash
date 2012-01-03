#!/bin/bash
. $HOME/bin/git-switch home
. $HOME/.bash_aliases
[ -n "$1" ] && export CONNECT_PASSWORD=$1
repo forall -vc "sync-project.bash"
