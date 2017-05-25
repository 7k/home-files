#!/bin/bash -x

cwd=$(cd "$(dirname "$0")"; pwd)
echo "installing from $cwd"
cd ~/

rm -rf .mc

[ -d bin ] && mv bin bin.bu
[ -d .vim ] && mv .vim .vim.bu

files="
bin
notes.txt
.mc
.nanorc
.virc
.vim
.vimrc
.toprc
.bash_prompt
.bash_aliases
.gitattributes
.tmux.conf
"

for i in $files ; do
  if [ ! -e $i -a ! -L $i ]; then
    ln -v -s $cwd/$i $i
  else
    mv $i $i.bak
    ln -v -s $cwd/$i $i
  fi
done

#which sudo 2>/dev/null && sudo cp -R $HOME/home/nanosyntax/nanosyntax/nano/*.nanorc /usr/share/nano/

# cp -a $cwd/.gitconfig* ~/
