#!/bin/bash
. $HOME/bin/git-switch home
. $HOME/.bash_aliases
[ -n "$1" ] && export CONNECT_PASSWORD=$1

while [ ! -e .repo ] && [ $PWD != "/" ]; do cd ../; done
if [ $PWD = "/" ]; then echo "Reached / of filesystem"; exit 1; fi
proj=$(cat .repo/manifests/.git/config | grep -e "url = " | sed "s/^.*.net\///")
echo $proj;
pushd .repo/manifests/
sync-project.bash $proj
popd

repo forall -vc "sync-project.bash"
