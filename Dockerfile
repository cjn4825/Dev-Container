FROM fedora:43

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
    ${MAINDIR}/.dotfiles \
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

CMD ["bash"]
