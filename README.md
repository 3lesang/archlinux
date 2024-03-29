# Arch Install Guide
First set up your keyboard layout. For example, in English:
```
   # loadkeys us
```
For a list of all acceptable keymaps:
```
   # localectl list-keymaps
```

## Pre-installation

### EFI-enabled BIOS
This guide assumes you have EFI-enabled BIOS. Let's check it out.
```
   # ls /sys/firmware/efi/efivars
```
When you run this command you should see a list of files.

### Internet connection
To make sure you have an internet connection, you have to ask Mr. Google:
```
   # ping 8.8.8.8
```

### Partition disk
Your primary disk will be known from now on as `sda`. You can check if
this is really your primary disk:
```
   # lsblk
```
Feel free to adapt the rest of the guide to `sdb` or any other if you
want to install Arch on a secondary hard drive.

This guide will use a 250GB hard disk and will have only Arch Linux installed.
You'll create 4 partitions of the disk (feel free to suit this to your needs).

* `/dev/sda1` boot partition (500M).
* `/dev/sda2` swap partition (4G).
* `/dev/sda3` root partition (50G).
* `/dev/sda4` home partition (remaining disk space).

You're going to start by removing all the previous partitions and creating
the new ones.
```
   # gdisk /dev/sda
```
This interactive CLI program allows you to enter commands for managing your HD.
I'm going to show you only the commands you need to enter.

#### Clear partitions table
```
   Command: O
   Y
```
#### EFI partition (boot)
```
   Command: N
   ENTER
   ENTER
   +500M
   ef00
```

#### SWAP partition
```
   Command: N
   ENTER
   ENTER
   +4G
   8200
```

#### Root partition (/)
```
   Command: N
   ENTER
   ENTER
   +50G
   8304
```

#### Home partition
```
   Command: N
   ENTER
   ENTER
   ENTER
   8302
```

#### Save changes and exit
```
   Command: W
   Y
```

### Format partitions
```
   # mkfs.fat -F32 /dev/sda1
   # mkswap /dev/sda2
   # mkfs.ext4 /dev/sda3
   # mkfs.ext4 /dev/sda4
```

### Mount partitions
```
   # swapon /dev/sda2
   # mount /dev/sda3 /mnt
   # mkdir /mnt/boot
   # mkdir /mnt/home
   # mount /dev/sda1 /mnt/boot
   # mount /dev/sda4 /mnt/home
```

If you run the `lsblk` command you should see something like this:
```
   NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
   sda      8:0    0 232.9G  0 disk
   ├─sda1   8:1    0     500M  0 part /mnt/boot
   ├─sda2   8:2    0     4G  0 part [SWAP]
   ├─sda3   8:3    0    50G  0 part /mnt
   └─sda4   8:4    0   100G  0 part /mnt/home
```

## Installation

### Update the system clock
```
   # timedatectl set-ntp true
```

### Install Arch packages
```
   # pacstrap /mnt base base-devel linux linux-firmware nano
```

### Generate fstab file
```
   # genfstab -U /mnt >> /mnt/etc/fstab
```

## Add basic configuration

### Enter the new system
```
   # arch-chroot /mnt
```

### Language-related settings
```
   # nano /etc/locale.gen
```
Now you have to uncomment the language of your choice, for example
`en_US.UTF-8 UTF-8`.
```
   # locale-gen
   # nano /etc/locale.conf
```
Add this content to the file:
```
   LANG=en_US.UTF-8
   LANGUAGE=en_US
   LC_ALL=C
```
```
   # nano /etc/vconsole.conf
```
Add this content to the file:
```
   KEYMAP=us
```

### Configure timezone
For this example I'll use "Asia/Ho_Chi_Minh", but adapt it to your zone.
```
   # ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
   # hwclock --systohc
```

### Enable NetworkManager
These services will be started automatically when the system boots up.
```
   # pacman -S networkmanager
   # systemctl enable NetworkManager
```

### Install bootloader
```
   # pacman -S grub efibootmgr
   # grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
   # grub-mkconfig -o /boot/grub/grub.cfg
```
You can replace "GRUB" with the id of your choice.

### Choose a name for your computer
Assuming your computer is known as "dell":
```
   # echo dell > /etc/hostname
```

### Adding content to the hosts file
```
   # nano /etc/hosts
```
And add this content to the file:
```
   127.0.0.1    localhost.localdomain   localhost
   ::1          localhost.localdomain   localhost
   127.0.0.1    dell.localdomain        dell
```
Replace "dell" with your computer name.

### Install other useful packages
```
   $ pacman -S iw wpa_supplicant dialog intel-ucode
```

### Update root password
```
   # passwd
```

### Final steps
```
   # exit
   # umount -R /mnt
   # swapoff /dev/sda2
   # reboot
```

## Post-install configuration

Now your computer has restarted and in the login window on the tty1 console you
can log in with the root user and the password chosen in the previous step.

### Add your user
Assuming your chosen user is "dell":
```
   # useradd -m -g users -G wheel,storage,power,video,audio,network dell
   # passwd dell
```

### Grant root access to our user
```
   # EDITOR=nvim visudo
```
If you prefer not to be prompted for a password every time you run a command
with "sudo" privileges you need to uncomment this line:
```
   %wheel ALL=(ALL) NOPASSWD: ALL
```
Or if you prefer the standard behavior of most Linux distros you need to
uncomment this line:
```
   %wheel ALL=(ALL) ALL
```

### Login into newly created user
```
   # su - dell
   $ xdg-user-dirs-update
```

### Install AUR package manager
In this guide we'll install [yay](https://github.com/Jguer/yay) as the
AUR package manager. More about [AUR](https://aur.archlinux.org/).

TL;DR AUR is a Community-driven package repository.
```
   $ mkdir sources
   $ cd sources
   $ git clone https://aur.archlinux.org/yay.git
   $ cd yay
   $ makepkg -si
```

### Manage Bluetooth
```
   $ sudo pacman -S bluez bluez-utils
   $ sudo systemctl enable bluetooth
```

## i3-gaps related steps

### Install graphical environment and i3
```
   $ sudo pacman -S xorg-server xorg-apps xorg-xinit xf86-video-intel
   $ sudo pacman -S i3-gaps i3status i3lock
```

### Install display manager
```
   $ sudo pacman -S lightdm lightdm-gtk-greeter
   $ sudo systemctl start lightdm.service
   $ sudo systemctl enable lightdm.service
```

### Install some basic fonts
```
   $ sudo pacman -S ttf-dejavu ttf-freefont ttf-fira-code
   $ sudo pacman -S ttf-liberation ttf-droid ttf-roboto terminus-font
```

### Install some useful tools on i3
```
   $ sudo pacman -S ranger rofi --needed
```


### Install Vietnamese fonts and input method in Arch Linux
```
   $ sudo pacman -S fcitx fcitx-unikey fcitx-im fcitx-configtool
```


### Install other useful packages
```
   $ sudo pacman -S git xclip scrot feh neovim xterm mpv xdg-user-dirs
   $ sudo pacman -S pulseaudio pulseaudio-bluetooth alsa-utils alsa-plugins
```

### Install packages by other way
```
   $ git clone https://github.com/nonesang/pkgarch.git
   $ cd pkgarch
   $ chmod +x install.sh
   $ ./install.sh
```
### Apply previous settings
```
   $ sudo reboot
```
