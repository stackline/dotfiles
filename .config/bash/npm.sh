#!/bin/bash

# NPM_CONFIG_USERCONFIG indicates the location of user-level configuration settings.
# Do not specify ${XDG_CONFIG_HOME}"/npm/npmrc as it may assume the default path ~/.npmrc.
export NPM_CONFIG_USERCONFIG=~/.npmrc
