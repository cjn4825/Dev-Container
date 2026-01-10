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

# create uid and gid values
ARG DEVUID=1000
ARG DEVGID=1000

# create user with home dir with ID values for user and group
RUN groupadd -g ${DEVGID} ${DEVUSER} \
 && useradd -m -u ${DEVUID} -g ${DEVGID} -s /bin/bash ${DEVUSER}

# create directorys and give user ownership
RUN mkdir -p \
    ${MAINDIR}/.config \
    ${MAINDIR}/.bashrc.d \
    ${MAINDIR}/workspace \
 && chown -R ${DEVUSER}:${DEVUSER} ${MAINDIR}

# test label to see if this fixes directory access issue
LABEL "devcontainer.settings"='{"workspaceFolder": "/home/devuser/workspace", "remoteUser": "devuser"}'

# set user
USER ${DEVUSER}

# set workdir
WORKDIR ${MAINDIR}/workspace

# download dotfiles
RUN git clone https://github.com/cjn4825/.dotfiles \
    ${MAINDIR}/.dotfiles

# run bootstrapping script to link dotfiles to config locations and update Neovim
RUN ${MAINDIR}/.dotfiles/scripts/bootstrap.sh

CMD ["bash"]
