FROM archlinux:base-devel

RUN pacman-key --init && \
    pacman -Syyu --noconfirm && \
    pacman -S --noconfirm reflector && \
    reflector -c "DE" -l 6 -f 6 -p https --ipv4 --save /etc/pacman.d/mirrorlist && \
    pacman --noconfirm --needed -Sy asciinema base-devel bat btop croc duf eza figlet fzf git github-cli gdu htop lynx mc micro nano neovim python rsync tldr tmux ufw unzip wget xclip zip

EXPOSE 80

RUN sed -ie '/^# Misc options/a Color' /etc/pacman.conf && \
    sed -ie '/^# Misc options/a ILoveCandy' /etc/pacman.conf && \
    sed -ie '/^# Misc options/a VerbosePkgLists' /etc/pacman.conf

# Add user and install yay
ARG user=arch
RUN useradd --system --create-home $user && \
    echo "$user ALL=(ALL:ALL) NOPASSWD: /usr/bin/makepkg" > /etc/sudoers.d/$user && \
    echo "$user ALL=(ALL:ALL) NOPASSWD: /usr/sbin/pacman" > /etc/sudoers.d/$user
# RUN echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user

USER $user
WORKDIR /home/$user/yay
RUN git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --needed --noconfirm && \
    yay --save --singlelineresults && \
    yay --save --builddir /home/$user/yay && \
    yay --answerupgrade=None --noconfirm -Sy pfetch botsay pixterm

RUN dd if=/dev/null of=/home/arch/.bashrc && \
    echo '[[ $- != *i* ]] && return' >> /home/arch/.bashrc && \
    echo -e 'mkcd() {\n mkdir -p "$1" && cd "$1"\n}' >> /home/arch/.bashrc && \
    echo "alias pacz='pacman -Slq | fzf --multi --preview \"pacman -Si {1}\" | xargs -ro sudo pacman -S'" >> ~/.bashrc && \
    echo "alias yayz='yay -Slq | fzf --multi --preview \"yay -Si {1}\" | xargs -ro yay -S'" >> ~/.bashrc && \
    echo "alias ea='eza -al --header --group --group-directories-first'" >> /home/arch/.bashrc && \
    echo "alias micro='micro -wordwrap true'" >> /home/arch/.bashrc && \
    echo "alias vim='nvim'" >> /home/arch/.bashrc && \
    echo "alias nano='nano --linenumbers --emptyline --mouse --indicator --magic'" >> /home/arch/.bashrc && \
    echo "alias clear='clear -x'" >> /home/arch/.bashrc && \
    echo "alias pixterm='pixterm -s 2'" >> /home/arch/.bashrc && \
    echo "alias lynx='lynx -accept_all_cookies -number_fields -number_links -use_mouse -scrollbar'" >> /home/arch/.bashrc && \
    echo "export EZA_COLORS='di=1;31:da=1;37:uu=1;31:gu=1;35:fi=1;37:sn=1;35'" >> /home/arch/.bashrc && \
    echo "export PS1='\[\e[0m\][\[\e[0;31m\]\u \[\e[0m\]@ \[\e[0;92m\]\w \[\e[0m\]@ \[\e[0;36m\]\t\[\e[0m\]] \[\e[0;97m\]\\$ \[\e[0;96m\]\$(git branch 2>/dev/null | grep '\"'\"'^*'\"'\"' | colrm 1 2) \[\e[0m\]'" >> /home/arch/.bashrc && \
    echo "export HISTSIZE=1000" >> /home/arch/.bashrc && \
    echo "export HISTFILESIZE=-1" >> /home/arch/.bashrc && \
    echo "export HISTCONTROL='erasedups:ignoredups'" >> /home/arch/.bashrc && \
    echo "export PROMPT_COMMAND='history -a'" >> /home/arch/.bashrc && \
    echo "export HISTTIMEFORMAT='%F %T '" >> /home/arch/.bashrc && \
    echo "source /usr/share/fzf/key-bindings.bash" >> /home/arch/.bashrc

COPY server-stack.sh /home/$user/
WORKDIR /home/$user
