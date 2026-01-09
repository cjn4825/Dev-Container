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
    fontconfig \
    && dnf clean all

# installs treesitter cli dependency
RUN npm install -g tree-sitter-cli

# creates build time variable for user's name
ARG DEVUSER=devuser
ARG MAINDIR=/home/${DEVUSER}

# add user and make shell
RUN useradd -m -s /bin/bash ${DEVUSER}

# create directorys and give user ownership
RUN mkdir -p \
    ${MAINDIR}/.config \
    ${MAINDIR}/.bashrc.d \
    ${MAINDIR}/.local/share/fonts \
 && chown -R ${DEVUSER}:${DEVUSER} ${MAINDIR} \
 && chown -R ${DEVUSER}:${DEVUSER} /workspaces/dev
 # should probably include logic in where if devpod is being used then do this
 # should probably just change it where devpod is required or include script in this repo
 # where you run it and it just pulls the dotfiles and runs the linking

# set user and init dir
USER ${DEVUSER}
WORKDIR ${MAINDIR}

# download dotfiles
RUN git clone https://github.com/cjn4825/.dotfiles \
    ${MAINDIR}/.dotfiles

# run bootstrapping script to link dot files to dirs
RUN ${MAINDIR}/.dotfiles/scripts/bootstrap.sh

# resets font cache...should remove this since the font is based on the terminal emulator used no from inside the container
RUN fc-cache

CMD ["bash"]
