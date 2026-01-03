# Docker Container for dev work
This project includes a dockerfile that can easily be turned into an image with dependencies already installed(as of now there isn't much, but its a work in progress for personal use, but this can be easly adapted to other uses also)

I have not tested if this works in different environments, and this is just work in progress meant to be a learning oppritunity for containerization via [Docker](https://docs.docker.com/get-started/docker-overview/).

# Goal
To learn more about containerization and eventually expain to include more security, functionality, and automation.

# Dependencies
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [docker](https://docs.docker.com/engine/install/)

# How to build image
'''Bash
  git clone git@github.com/cjn4825/Dev-Container
  cd Dev-Container
  # don't have to do sudo if root
  sudo docker build -t {image name of your choosing} .
  sudo coker build -it {image name}
'''


