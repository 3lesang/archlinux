#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias reboot="systemctl reboot"
neofetch

[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null
