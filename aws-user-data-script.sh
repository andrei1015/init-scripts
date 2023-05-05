#!/bin/bash

echo "+++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++SCRIPT START+++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
timedatectl set-timezone Europe/Amsterdam

# PACMAN INIT

pacman-key --init
pacman-key --populate
reflector --country "NL" --protocol https,http --score 20 --sort rate --save /etc/pacman.d/mirrorlist
# pacman --noconfirm -Sy archlinux-keyring
# pacman-key --populate archlinux

pacman --noconfirm -Syyu

# MY PREFERENCE OF BASIC MUST HAVE PACKAGES
rm /var/lib/pacman/db.lck
pacman --noconfirm --needed -Sy base-devel asciinema bat croc duf git github-cli micro nano htop btop mc tmux python exa wget ncdu figlet zip unzip rsync lynx

echo "nameserver 1.1.1.1"  >>  /etc/resolv.conf

# INSTALL YAY BECAUSE WHY EVEN USE PACMAN?
mkdir /home/arch/yay
cd /home/arch/yay
git clone https://aur.archlinux.org/yay-bin.git
chown -R arch:arch /home/arch/yay
runuser -l  arch -c 'cd /home/arch/yay/yay-bin; makepkg -si --noconfirm PKGBUILD'
runuser -l  arch -c 'yay --save --singlelineresults'
runuser -l  arch -c 'yay --save --builddir /home/arch/yay'


# HISTORY IS A BIT FUNKY OUT OF THE BOX
touch /home/arch/.bash_history
chown -R arch:arch /home/arch/.bash_history
# shopt -s histappend

# DO STUFF IN .BASHRC
dd if=/dev/null of=/home/arch/.bashrc
echo '[[ $- != *i* ]] && return'  >>  /home/arch/.bashrc
echo "alias ea='exa -al --header --group --group-directories-first'"  >>  /home/arch/.bashrc
echo "alias nano='nano --linenumbers --emptyline --mouse --indicator --magic'"  >>  /home/arch/.bashrc
echo "alias cht='cht.sh'"  >>  /home/arch/.bashrc
echo "alias clear='clear -x'"  >>  /home/arch/.bashrc
echo "alias pixterm='pixterm -s 2'"  >>  /home/arch/.bashrc
echo "alias lynx='lynx -accept_all_cookies -number_fields -number_links -use_mouse -scrollbar'"  >>  /home/arch/.bashrc
echo "export EXA_COLORS='di=1;31:da=1;37:uu=1;31:gu=1;35:fi=1;37:sn=1;35'"  >>  /home/arch/.bashrc
echo "export PS1='\[\e[0m\][\[\e[0;31m\]\u \[\e[0m\]@ \[\e[0;92m\]\w \[\e[0m\]@ \[\e[0;36m\]\t\[\e[0m\]] \[\e[0;97m\]\\$ \[\e[0;96m\]\$(git branch 2>/dev/null | grep '\"'\"'^*'\"'\"' | colrm 1 2) \[\e[0m\]'"  >>  /home/arch/.bashrc

# HISTORY SHENANIGANS IN BASHRC
echo "export HISTSIZE=-1"  >>  /home/arch/.bashrc
echo "export HISTFILESIZE=-1"  >>  /home/arch/.bashrc
echo "export HISTCONTROL='erasedups'"  >>  /home/arch/.bashrc
echo "export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '"  >>  /home/arch/.bashrc
echo "alias hs='history | grep'"  >>  /home/arch/.bashrc

# MAKE PACMAN/YAY BEAUTIFUL
sed -ie '/^# Misc options/a Color' /etc/pacman.conf
sed -ie '/^# Misc options/a ILoveCandy' /etc/pacman.conf

#YAY FUN
touch /home/arch/aur-init-install.log
runuser -l  arch -c 'yay --answerupgrade=None --noconfirm -Sy pfetch botsay pixterm cht.sh-git'  >> /home/arch/aur-init-install.log
rm /var/lib/pacman/db.lck
runuser -l  arch -c 'yay --noconfirm --answerupgrade=None -Yc'

# ADD BOTSAY TO MOTD FOR FUN OF COURSE

dd if=/dev/null of=/etc/motd

echo -e 'botsay -c "Welcome to 🐧 Arch btw!"' >> /home/arch/.bash_profile

echo "+++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++SCRIPT END+++++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
