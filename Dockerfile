FROM fedora:43

# TODO:
    # get working and remove any unnessesary packages like debugging
    # get regular networking tools such as ip a working...or actually no? since it will be used to ssh into other systems or should i do that via normal host?
    # fix error code when starting nvim
    # auto get nvim to download packages
    # hardening research

# NOTES:
    # pass environment variables to container in runtime not baked into container...specifically vault keys in my case for now

# update system and install dependencies
RUN dnf update -y && dnf install -y \
    neovim \
    git \
    neovim \
    curl \
    tmux \
    python3 \
    ansible \
    python3-pip \
    npm \
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

# download dot files and move to dir
RUN git clone https://github.com/cjn4825/Dev-Dotfiles \
    ${MAINDIR}/dotfiles

RUN mv ${MAINDIR}/dotfiles/nvim ${MAINDIR}/.config/
RUN mv ${MAINDIR}/dotfiles/tmux/.tmux.conf ${MAINDIR}/.tmux.conf
RUN mv ${MAINDIR}/dotfiles/tmux/.tmux ${MAINDIR}/.tmux
RUN mv ${MAINDIR}/dotfiles/bash/.bashrc.d/prompt.sh ${MAINDIR}/.bashrc.d/prompt.sh
RUN rm -rf ${MAINDIR}/dotfiles

CMD ["/bin/bash"]
