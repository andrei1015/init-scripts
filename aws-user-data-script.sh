#!/bin/bash

echo "+++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++SCRIPT START+++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
timedatectl set-timezone Europe/Amsterdam

# 1. 👋 Welcome to PACMAN INIT - where we unleash the 💪 power of Arch Linux 📦 package management with the mighty 🐊 PACMAN at our fingertips.
pacman-key --init
pacman-key --populate
reflector --fastest 5 --latest 5 --completion-percent 100 --sort rate --protocol https --verbose --country NL,DE --delay 0.15 --save /etc/pacman.d/mirrorlist
pacman --noconfirm -Syyu

# 2. Behold, my preference of basic packages that must needs be present in mine system.
rm /var/lib/pacman/db.lck
pacman --noconfirm --needed -Sy asciinema base-devel bat btop cockpit cockpit-storaged cockpit-pcp cockpit-packagekit croc duf eza figlet fzf git github-cli gdu htop lynx mc micro nano neovim networkmanager python rsync tldr tmux ufw unzip wget xclip zip

# 3. 🌐 Network Stuff: 🔑 5 Secrets Every Dev Needs to Know (and Why Some of Them Are Hated) 😡
# echo "nameserver 1.1.1.1"  >>  /etc/resolv.conf
# ufw allow 80/tcp comment "HTTP"
# ufw allow 443/tcp comment "HTTPS"
# ufw allow 22/tcp comment "SSH"
# ufw enable

# 4. Me say use 🙌 paru for package management. Paru make everything easy-peasy like berries 🍓 on bush. No need hunt 🏹 and gather 🧺 for packages like Neanderthal. 🦕
runuser -l arch -c 'mkdir /home/arch/git'
cd /home/arch/git
runuser -l arch -c 'git clone https://aur.archlinux.org/paru-bin.git'
runuser -l arch -c 'cd /home/arch/git/paru-bin; makepkg -si --noconfirm'

# 5. I have just the sonic screwdriver 🔧 you need to fix history ⏰. With a simple flick of the wrist 💫 and a few choice commands 💻, we'll have that timeline back in ship-shape 🚀 in no time.
touch /home/arch/.bash_history
chown -R arch:arch /home/arch/.bash_history
# shopt -s histappend

# 6. Make your terminal a cozy home 🏠 with proper .bashrc configuration - let me show you how! 💻
dd if=/dev/null of=/home/arch/.bashrc
echo '[[ $- != *i* ]] && return' >>/home/arch/.bashrc
echo -e 'mkcd() {\n    mkdir -p "$1" && cd "$1"\n}' >>/home/arch/.bashrc
echo "alias pacz='pacman -Slq | fzf --multi --preview \"pacman -Si {1}\" | xargs -ro sudo pacman -S'" >>/home/arch/.bashrc
echo "alias paruz='paru -Slq | fzf --multi --preview \"paru -Si {1}\" | xargs -ro paru -S'" >>/home/arch/.bashrc
echo "alias ea='eza -al --header --group --group-directories-first'" >>/home/arch/.bashrc
echo "alias nano='nano --linenumbers --emptyline --mouse --indicator --magic'" >>/home/arch/.bashrc
echo "alias clear='clear -x'" >>/home/arch/.bashrc
echo "alias vim='nvim'" >>/home/arch/.bashrc
echo "alias pixterm='pixterm -s 2'" >>/home/arch/.bashrc
echo "alias lynx='lynx -accept_all_cookies -number_fields -number_links -use_mouse -scrollbar'" >>/home/arch/.bashrc
echo "export EXA_COLORS='di=1;31:da=1;37:uu=1;31:gu=1;35:fi=1;37:sn=1;35'" >>/home/arch/.bashrc
echo "export PS1='\[\e[0m\][\[\e[0;31m\]\u \[\e[0m\]@ \[\e[0;92m\]\w \[\e[0m\]@ \[\e[0;36m\]\t\[\e[0m\]] \[\e[0;97m\]\\$ \[\e[0;96m\]\$(git branch 2>/dev/null | grep '\"'\"'^*'\"'\"' | colrm 1 2) \[\e[0m\]'" >>/home/arch/.bashrc

# 7. 🚂 All aboard! 🛤️ Add some history properties to your .bashrc file and keep track of your terminal's journey like a seasoned traveler. 🧳
echo "export HISTSIZE=1000" >>/home/arch/.bashrc
echo "export HISTFILESIZE=-1" >>/home/arch/.bashrc
echo "export HISTCONTROL='erasedups:ignoredups'" >>/home/arch/.bashrc
echo "export PROMPT_COMMAND='history -a'" >>/home/arch/.bashrc
echo "export HISTTIMEFORMAT='%F %T '" >>/home/arch/.bashrc
echo "source /usr/share/fzf/key-bindings.bash" >>/home/arch/.bashrc

# 8. Don't settle for a basic package manager, hun! 💅 Let's put on some makeup and turn Pacman/paru into a fierce and fabulous superstar. 💄🌟 With custom configurations and colorful themes, your terminal will be serving looks for days! 👑
sed -ie '/^# Misc options/a Color' /etc/pacman.conf
sed -ie '/^# Misc options/a ILoveCandy' /etc/pacman.conf
sed -ie '/^# Misc options/a VerbosePkgLists' /etc/pacman.conf

# 9. Upgrade your terminal game with paru and get the hottest apps in town! 🚀🔥 From productivity to gaming, we've got it all. Let's roll! 🎮💻
touch /home/arch/aur-init-install.log
runuser -l arch -c 'paru --noconfirm -S pfetch botsay pixterm cockpit-navigator' >>/home/arch/aur-init-install.log
rm /var/lib/pacman/db.lck

systemctl start cockpit.socket
systemctl enable cockpit.socket
systemctl enable NetworkManager
systemctl start NetworkManager

# Final step, brave warrior! We finish strong with customizing your terminal to match your battle gear! ⚔️🛡️ Show off your skills with a sleek prompt and MOTD! Valhalla awaits! 🙌🔥

dd if=/dev/null of=/etc/motd

echo -e 'botsay -c "Welcome to Arch btw!"' >>/home/arch/.bash_profile

echo "+++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++SCRIPT END+++++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
