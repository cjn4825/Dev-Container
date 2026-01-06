FROM fedora:43

# TODO:
    # get working and remove any unnessesary packages like debugging in nvim
    # fix error code when starting nvim
    # auto get nvim to download packages
    # hardening research

# NOTES:
    # pass environment variables to container in runtime not baked into container...specifically vault keys in my case for now

# update system and install dependencies
RUN dnf update -y && dnf install -y \
    bash \
    neovim \
    git \
    curl \
    tmux \
    python3 \
    ansible \
    python3-pip \
    npm \
    procps-ng \
    util-linux \
    iproute \
    iputils \
    net-tools \
    ca-certificates \
    && dnf clean all

# python tooling
RUN pip3 install \
    pynvim

# node tooling for language servers
RUN npm install -g \
    neovim \
    typescript \
    bash-language-server \
    yaml-language-server

# creates build time variable for user's name
ARG DEVUSER=devuser
ARG MAINDIR=/home/${DEVUSER}

# add user and make shell
RUN useradd -m -s /bin/bash ${DEVUSER}

# create directorys and give user ownership
RUN mkdir -p \
    ${MAINDIR}/.config \
    ${MAINDIR}/.bashrc.d \
    ${MAINDIR}/.tmux/plugins \
 && chown -R ${DEVUSER}:${DEVUSER} ${MAINDIR}

# set user and init dir
USER ${DEVUSER}
WORKDIR ${MAINDIR}

# download tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm \
    ${MAINDIR}/.tmux/plugins/tpm

# download dotfiles and run bootstrap script to link files
RUN git clone https://github.com/cjn4825/.dotfiles \
    ${MAINDIR}/.dotfiles \ 
    $$ ./${MAINDIR}/.dotfiles/scripts/bootstrap.sh


# back when i didn't use symlinks ... will remove later
# ARG DOTFILES=${MAINDIR}/.dotfiles
#RUN mv ${DOTFILES}/nvim ${MAINDIR}/.config/
#RUN mv ${DOTFILES}/tmux/.tmux.conf ${MAINDIR}/.tmux.conf
#RUN mv ${DOTFILES}/tmux/.tmux ${MAINDIR}/.tmux
#RUN mv ${DOTFILES}/bash/.bashrc.d/prompt.sh ${MAINDIR}/.bashrc.d/prompt.sh

CMD ["/usr/bin/env bash"]
