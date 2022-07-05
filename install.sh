#!/bin/bash

sudo pacman -S xorg-server xorg-apps xorg-xinit xf86-video-intel i3-gaps i3status i3lock lightdm lightdm-gtk-greeter bluez bluez-utils ranger rofi pulseaudio pulseaudio-bluetooth alsa-utils alsa-plugins fcitx fcitx-unikey fcitx-im fcitx-configtool xclip scrot feh neovim xterm mpv xdg-user-dirs ttf-liberation ttf-droid ttf-roboto terminus-font ttf-dejavu ttf-freefont ttf-fira-code 

sudo systemctl enable bluetooth
sudo systemctl enable lightdm.service
