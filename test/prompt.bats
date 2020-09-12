#!/usr/bin/env bats

function setup() {
  source "$(git rev-parse --show-toplevel)/.config/bash/prompt.sh"
  readonly bats_test_suite_tmpdir="$(pwd)/bats-test-tmp"
  readonly git_prompt_file_path="$bats_test_suite_tmpdir/etc/bash_completion.d"
  mkdir -p "$bats_test_suite_tmpdir/etc/bash_completion.d"
}

function teardown() {
  rm -rf "$bats_test_suite_tmpdir"
}

@test "When dependencies are missing, terminate with error status" {
  unset HOMEBREW_PREFIX

  run prompt::initialize

  [ "$status" -eq 1 ]
  [ "${lines[0]}" = 'warning: HOMEBREW_PREFIX variable is empty. Please check Homebrew config.' ]
  [ "${lines[1]}" = 'warning: git-prompt.sh does not exist. Please install git with Homebrew.' ]
}

@test "When dependencies are satisfied, return success" {
  HOMEBREW_PREFIX="$bats_test_suite_tmpdir"
  touch "$git_prompt_file_path/git-prompt.sh"

  # NOTE: The run helper executes the function in a subshell,
  # so it does not change PS1 of the current shell.
  prompt::initialize
  status=$?

  [ "$status" -eq 0 ]
  [[ "$PS1" = *__git_ps1* ]]
}
