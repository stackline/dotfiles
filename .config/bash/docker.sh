#!/bin/bash

export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

# NOTE: From 4.18, docker desktop for mac installs symbolic links under home.
# ref. https://docs.docker.com/desktop/mac/permission-requirements/#installing-symlinks
export PATH=$PATH:$HOME/.docker/bin

# NOTE: The default value for DOCKER_HOST is "unix:///var/run/docker.sock".
# /var/run/docker.sock is deleted when macos is restarted.
# Therefore, after restarting macos, it is necessary to do one of the following.
#
# (a) Manually create a symbolic link.
# (b) Specify the docker socket path in DOCKER_HOST.
#
# If you use Docker Desktop for Mac and choose (b), specify DOCKER_HOST as follows:
# export DOCKER_HOST=unix://$HOME/.docker/run/docker.sock
