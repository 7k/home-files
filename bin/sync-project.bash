#!/bin/bash -x
echo `pwd`;
if [ -n "$1" ]; then
  proj=$1
else
  proj=`cat .git/config | grep -o 'projectname = \(.*\)' | grep -o '[^= ]*$'`;
fi
echo $proj;
socks-ssh -p 29418 tak.kanemoto@tak.atso-net.jp gerrit create-project --name $proj;
git push git://tak.atso-net.jp/$proj +refs/remotes/origin/*:refs/heads/*;
git push git://tak.atso-net.jp/$proj +refs/heads/*:refs/topics/*;
