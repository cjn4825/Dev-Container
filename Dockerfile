FROM fedora:43

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
    gzip \
    xz \
    make \
    gcc \
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
 && chown -R ${DEVUSER}:${DEVUSER} ${MAINDIR}

# set user
USER ${DEVUSER}

# workspace is set under the devcontainer convention + dev container name
WORKDIR ${MAINDIR}

# download dotfiles
RUN git clone https://github.com/cjn4825/.dotfiles \
    ${MAINDIR}/.dotfiles

# run bootstrapping script to link dotfiles to config locations and update Neovim
RUN ${MAINDIR}/.dotfiles/scripts/bootstrap.sh

CMD ["bash"]
