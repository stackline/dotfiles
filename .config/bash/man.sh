#!/bin/bash

# Colorize manual pages
#
#   mb = start blink
#   md = start bold
#   me = turn off blink and bold
#
#   so = start standout
#   se = stop standout
#
#   us = start underline
#   ue = stop underline
#
#   31 = red
#   32 = green
#   33 = yellow
#
function man() {
  LESS_TERMCAP_mb=$'\e[01;32m' \
    LESS_TERMCAP_md=$'\e[01;32m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;33m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[04;31m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    command man "$@"
}
