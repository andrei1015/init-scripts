FROM archlinux:base-devel

RUN pacman-key --init
RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm reflector
RUN reflector -c "DE" -l 6 -f 6 -p https --ipv4 --save /etc/pacman.d/mirrorlist

RUN pacman --noconfirm --needed -Sy iptables asciinema base-devel bat btop croc duf eza figlet fzf git github-cli gdu htop lynx mc micro nano neofetch neovim python rsync tmux ufw unzip wget xclip zip

EXPOSE 80

RUN sed -ie '/^# Misc options/a Color' /etc/pacman.conf
RUN sed -ie '/^# Misc options/a ILoveCandy' /etc/pacman.conf
RUN sed -ie '/^# Misc options/a VerbosePkgLists' /etc/pacman.conf

# Add user and install yay
ARG user=arch
RUN useradd --system --create-home $user
# RUN echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
RUN echo "$user ALL=(ALL:ALL) NOPASSWD: /usr/bin/makepkg" > /etc/sudoers.d/$user
RUN echo "$user ALL=(ALL:ALL) NOPASSWD: /usr/sbin/pacman" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user
RUN git clone https://aur.archlinux.org/yay.git

WORKDIR yay
RUN makepkg -si --needed --noconfirm
RUN yay --save --singlelineresults
RUN yay --save --builddir /home/$user/yay
RUN yay --answerupgrade=None --noconfirm -Sy pfetch botsay pixterm cht.sh-git

RUN dd if=/dev/null of=/home/$user/.bashrc
RUN echo '[[ $- != *i* ]] && return'  >>  /home/$user/.bashrc
RUN echo -e 'mkcd() {\n    mkdir -p "$1" && cd "$1"\n}' >> /home/$user/.bashrc
RUN echo "alias ea='exa -al --header --group --group-directories-first'"  >>  /home/$user/.bashrc
RUN echo "alias nano='nano --linenumbers --emptyline --mouse --indicator --magic'"  >>  /home/$user/.bashrc
RUN echo "alias cht='cht.sh'"  >>  /home/$user/.bashrc
RUN echo "alias clear='clear -x'"  >>  /home/$user/.bashrc
RUN echo "alias pixterm='pixterm -s 2'"  >>  /home/$user/.bashrc
RUN echo "alias lynx='lynx -accept_all_cookies -number_fields -number_links -use_mouse -scrollbar'"  >>  /home/$user/.bashrc
RUN echo "export EXA_COLORS='di=1;31:da=1;37:uu=1;31:gu=1;35:fi=1;37:sn=1;35'"  >>  /home/$user/.bashrc
RUN echo "export PS1='\[\e[0m\][\[\e[0;31m\]\u \[\e[0m\]@ \[\e[0;92m\]\w \[\e[0m\]@ \[\e[0;36m\]\t\[\e[0m\]] \[\e[0;97m\]\\$ \[\e[0;96m\]\$(git branch 2>/dev/null | grep '\"'\"'^*'\"'\"' | colrm 1 2) \[\e[0m\]'"  >>  /home/$user/.bashrc

RUN echo "export HISTSIZE=-1"  >>  /home/$user/.bashrc
RUN echo "export HISTFILESIZE=-1"  >>  /home/$user/.bashrc
RUN echo "export HISTCONTROL='erasedups'"  >>  /home/$user/.bashrc
RUN echo "export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '"  >>  /home/$user/.bashrc
RUN echo "alias hs='history | grep'"  >>  /home/$user/.bashrc

COPY server-stack.sh /home/$user/
WORKDIR /home/$user
