#!/bin/bash

# NOTE: From 4.18, docker desktop for mac installs symbolic links under home.
#
# TODO: You have to manually create a symbolic link to the docker socket created
# under home directory.
#
# ref. https://docs.docker.com/desktop/mac/permission-requirements/#installing-symlinks
export PATH=$PATH:$HOME/.docker/bin
