FROM fedora:43

# TODO:
    # get working and remove any unnessesary packages like debugging in nvim
    # fix error code when starting nvim
    # auto get nvim to download packages
    # hardening research

# update system and install dependencies
RUN dnf update -y && dnf install -y \
    bash \
    neovim \
    git \
    curl \
    tmux \
    wget \
    unzip \
    tar \
    gtar \
    gzip \
    xz \
    make \
    gcc \
    lua \
    terraform \
    shellcheck \
    python3 \
    ansible \
    procps-ng \
    util-linux \
    iproute \
    wl-copy \
    iputils \
    ca-certificates \
    nodejs \
    ripgrep \
    fd-find \
    && dnf clean all

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

# download dotfiles
RUN git clone https://github.com/cjn4825/.dotfiles \
    ${MAINDIR}/.dotfiles

# run bootstrapping script to link dot files to dirs
RUN ${MAINDIR}/.dotfiles/scripts/bootstrap.sh

# resets font cache
RUN fc-cache -fv

CMD ["bash"]
