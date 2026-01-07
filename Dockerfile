FROM fedora:43

# TODO:
    # get working and remove any unnessesary packages like debugging in nvim
    # fix error code when starting nvim
    # auto get nvim to download packages
    # hardening research

# set environment variables for Go and Cargo Dependencies for some neovim plugins
ENV GOPATH=/go
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=$GOPATH/bin:$CARGO_HOME/bin:$PATH

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
    xz \
    make \
    gcc \
    gcc-c++ \
    lua \
    lua-devel \
    luarocks \
    cargo \
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
    nodejs \
    && dnf clean all

# go install
ENV GO_VERSION=1.21.1
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm -f /tmp/go.tar.gz

# Configure Go environment variables
ENV PATH=/usr/local/go/bin:$PATH

# install jsregexp
npm install -g jsregexp

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

# download dotfiles
RUN git clone https://github.com/cjn4825/.dotfiles \
    ${MAINDIR}/.dotfiles

# run bootstrapping script to link dot files to dirs
RUN ${MAINDIR}/.dotfiles/scripts/bootstrap.sh

CMD ["bash"]
