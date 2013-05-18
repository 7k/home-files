#!/bin/bash

cwd=`dirname "$0"`
# cwd=`readlink -f $cwd`
echo "installing from $cwd"
cd ~/

rm -rf ~/.mc

[ -d ~/bin ] && mv ~/bin ~/bin.bu
[ -d ~/.vim ] && mv ~/.vim ~/.vim.bu

for i in bin notes.txt .mc .nanorc .virc .vim .toprc .bash_prompt .bash_aliases .gitattributes; do
    [ ! -h ~/$i ] && ln -v -s $cwd/$i ~/$i  || echo "W: ~/$i exists"
done
# [ ! -e ~/.vimrc ] 		&& ln -s $cwd/.virc ~/.vimrc

which sudo 2>/dev/null && sudo cp -R $HOME/home/nanosyntax/nanosyntax/nano/*.nanorc /usr/share/nano/

# cp -a $cwd/.gitconfig* ~/
