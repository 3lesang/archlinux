#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -e $HOME/.alias ]; then
	[ -n "$PS1" ] && . $HOME/.alias
fi
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
