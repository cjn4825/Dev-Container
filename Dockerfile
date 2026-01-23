FROM fedora:43

# Comments out the 'tsfLags=nodocs' setting in /etc/dnf/dnf/conf so man pages can be installed
RUN sed -i '/tsflags=nodocs/s/^/#/' /etc/dnf/dnf.conf

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
    gtar \
    xz \
    make \
    gcc \
    shellcheck \
    luarocks \
    python3 \
    pip3 \
    procps-ng \
    util-linux \
    iproute \
    iputils \
    ca-certificates \
    nodejs \
    ripgrep \
    fd-find \
    man \
    man-pages \
    && dnf clean all

# install jsregexp dependency for lualine in neovim
RUN luarocks install jsregexp

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
    ${MAINDIR}/workspaces \
 && chown -R ${DEVUSER}:${DEVUSER} ${MAINDIR}

# set user
USER ${DEVUSER}

# download dotfiles
RUN git clone https://github.com/cjn4825/.dotfiles \
    ${MAINDIR}/.dotfiles

# run bootstrapping script to link dotfiles to config locations and update Neovim
RUN ${MAINDIR}/.dotfiles/scripts/bootstrap.sh

# set working dir to workspaces
WORKDIR ${MAINDIR}/workspaces

# start in tmux test
RUN tmux

# commented out for testing to see if i don't need this
#CMD ["bash"]
