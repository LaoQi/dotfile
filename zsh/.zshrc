# 通用
#setterm -blength 0
#编辑器
export EDITOR=vim

# auto ad `cd` to dir
setopt autocd

SearchHostsConfig() {
	if [[ -f ~/.ssh/config ]] then
		grep -v "HostName" ~/.ssh/config | grep Host | cut -d' ' -f2
	fi
}
#补全 ssh scp sftp 等
#zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=($(SearchHostsConfig))'
 
################# alias ##############################
alias v='vim'
alias vi='vim'
alias t='tree'
alias svnm='svn status | grep M'
alias gs='git status'
alias ga='git add'
alias gl='git log'
alias gc='git checkout'
alias gf='git fetch'
alias gd='git diff'
alias gm='git commit -m'
alias gclone='git clone'
alias vga='xrandr --output VGA-0 --right-of LVDS --mode'
################# alias END  ###########################
#
################# color ################################
autoload colors
colors
 
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval $color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"
#######################################################

################# PROMPT ###########################

# 关闭grml prompt
if [[ prompt ]]; then
    prompt off
fi 

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
# zstyle ':vcs_info:git*' formats "%{$fg[grey]%}%s %{$reset_color%}%r/%S%{$fg[grey]%} %{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%} "
zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b %m%u%c "

#FAILED_OUT='*_·'
FAILED_OUT=':('
#SUCCESS_OUT='·ω·'
#SUCCESS_OUT='·‿·'
SUCCESS_OUT=':)'

myprecmd() {
    vcs_info
PROMPT=$(echo "$_RED - $CYAN%l$_RED - $_YELLOW%D %T$RED - $BLUE%~ $RED ${vcs_info_msg_0_}
%(?.$GREEN$SUCCESS_OUT.$RED$FAILED_OUT $?) $WHITE>> $FINISH")
}

# add myprecmd
setopt prompt_subst
add-zsh-hook precmd myprecmd

################# PROMPT END ############################

################# title taskbar ######################
case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
#precmd () { print -Pn "\e]0;%n@%M//%/\a" }
#preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" }
precmd () { print -Pn "\e]0;%/\a" }
preexec () { print -Pn "\e]0;%/\ $1\a" }
;;
esac
################# title taskbar END ###################
 
