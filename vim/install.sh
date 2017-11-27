#!/bin/sh
cd `dirname $0`
VIM_PATH=`pwd`

ln -s $VIM_PATH ~/.vim

mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/colors

wget -O ~/.vim/colors/molokai.vim "https://raw.githubusercontent.com/fatih/molokai/master/colors/molokai.vim"
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1

vim ~/.vim/vimrc
