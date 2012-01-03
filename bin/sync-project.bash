#!/bin/bash -x
echo `pwd`;
proj=`cat .git/config | grep -o 'projectname = \(.*\)' | grep -o '[^= ]*$'`;
echo $proj;
socks-ssh -p 29418 tak.kanemoto@tak.atso-net.jp gerrit create-project --name $proj;
git push git://tak.atso-net.jp/$proj +refs/remotes/origin/*:refs/heads/*;
