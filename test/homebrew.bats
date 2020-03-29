#!/usr/bin/env bats

function setup() {
  source "$(git rev-parse --show-toplevel)/.config/bash/homebrew.sh"
}

function teardown() {
  :
}

@test "When OS is Mac, set environment variables for Mac" {
  # mock function
  function uname() {
    echo 'Darwin'
  }

  unset HOMEBREW_PREFIX
  homebrew::initialize
  status=$?

  [ "$status" -eq 0 ]
  [ "$HOMEBREW_PREFIX" = '/usr/local' ]
}

@test "When OS is Linux, set environment variables for Linux" {
  # mock function
  function uname() {
    echo 'Linux'
  }

  unset HOMEBREW_PREFIX
  homebrew::initialize
  status=$?

  [ "$status" -eq 0 ]
  [ "$HOMEBREW_PREFIX" = '/home/linuxbrew/.linuxbrew' ]
}

@test "When OS is neither Mac nor Linu, terminate with error status" {
  # mock function
  function uname() {
    echo 'Windows'
  }

  unset HOMEBREW_PREFIX
  run homebrew::initialize

  [ "$status" -eq 1 ]
  [ "${lines[0]}" = 'warning: OS name is neither Mac nor Linux.' ]
  [ "$HOMEBREW_PREFIX" = '' ]
}
