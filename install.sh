#!/bin/bash

sudo pacman -S bluez bluez-utils
sudo systemctl enable bluetooth

sudo pacman -S xorg-server xorg-apps xorg-xinit xf86-video-intel
sudo pacman -S i3-gaps i3status i3lock


sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl start lightdm.service
sudo systemctl enable lightdm.service

sudo pacman -S ranger rofi --needed
sudo pacman -S ttf-dejavu ttf-freefont ttf-fira-code
sudo pacman -S ttf-liberation ttf-droid ttf-roboto terminus-font
sudo pacman -S git xclip scrot feh neovim xterm mpv xdg-user-dirs
sudo pacman -S pulseaudio pulseaudio-bluetooth alsa-utils alsa-plugins
sudo pacman -S fcitx fcitx-unikey fcitx-im fcitx-configtool
