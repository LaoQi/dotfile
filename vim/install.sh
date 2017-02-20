#!/bin/sh
cd `dirname $0`
VIM_PATH=`pwd`

ln -s $VIM_PATH ~/.vim

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/tmp

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1

vim ~/.vim/vimrc
