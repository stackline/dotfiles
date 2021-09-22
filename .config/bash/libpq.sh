#!/bin/bash

# TODO: check the installation of libpq formula
if is_mac; then
  export PATH="/usr/local/opt/libpq/bin:${PATH}"
fi
if is_linux; then
  echo 'warning: not implemented'
fi
