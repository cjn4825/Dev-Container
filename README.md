# Docker Container for dev work

I plan on deleting this later since my workflow does not need a dockerfile anymore. I'm keeping this for now since I might need the .github/workflows file as reference in the future.

This project includes a dockerfile that can easily be turned into an image with dependencies already installed(as of now there isn't much, but its a work in progress for personal use, but this can be easly adapted to other uses also)

I have not tested if this works in different environments, and this is just work in progress meant to be a learning oppritunity for containerization via [Docker](https://docs.docker.com/get-started/docker-overview/).

# Disclaimer

This project is a work in progress and currently in development.

# Goal
To learn more about containerization and eventually expain to include more security, functionality, and automation.

# Dependencies
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [docker](https://docs.docker.com/engine/install/)

# How to build image
```bash
git clone https://github.com/cjn4825/Dev-Container
cd Dev-Container
# don't have to do sudo if root
sudo docker build -t <image-name> .
sudo doker run -it <image-name>
```










