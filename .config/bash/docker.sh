#!/bin/bash

# NOTE: From 4.18, docker desktop for mac installs symbolic links under home.
# ref. https://docs.docker.com/desktop/mac/permission-requirements/#installing-symlinks
export PATH=$PATH:$HOME/.docker/bin
