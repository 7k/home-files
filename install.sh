#!/bin/bash

cwd=`dirname "$0"`
# cwd=`readlink -f $cwd`
echo "installing from $cwd"
cd ~/

rm -rf .mc

[ -d bin ] && mv bin bin.bu
[ -d .vim ] && mv .vim .vim.bu

for i in bin notes.txt .mc .nanorc .virc .vim .toprc .bash_prompt .bash_aliases .gitattributes; do
  if [ ! -e $i ]; then
    ln -v -s $cwd/$i $i
  else
    mv $i $i.bak
    ln -v -s $cwd/$i $i
  fi
done

[ -e .virc ] && mv .virc .virc.bak
ln -s $cwd/.virc .vimrc

#which sudo 2>/dev/null && sudo cp -R $HOME/home/nanosyntax/nanosyntax/nano/*.nanorc /usr/share/nano/

# cp -a $cwd/.gitconfig* ~/
