#!/usr/bin/env bats

function setup() {
  readonly root_dir="$(git rev-parse --show-toplevel)"
  readonly file="$root_dir/.config/profile.d/go_to_repository.sh"
  source $file

  readonly current_dir="$(pwd)"
  readonly bats_test_suite_tmpdir="$current_dir/bats-test-tmp"
  mkdir $bats_test_suite_tmpdir
}

function teardown() {
  rmdir $bats_test_suite_tmpdir
}

@test "Check that ghq command is available" {
  command -v ghq
}

@test "Check that fzf command is available" {
  command -v fzf
}

@test "When directory exists, move to selected directory" {
  # mock
  function fzf() {
    echo $bats_test_suite_tmpdir
  }

  go_to_repository
  readonly moved_dir=$(pwd)
  [ "$moved_dir" = "$bats_test_suite_tmpdir" ]
}

@test "When directory doesn't exist, don't move to selected directory" {
  # mock
  function fzf() {
    readonly bats_test_suite_non_existent_dir="$current_dir/bats-test-non-existent-tmp"
    echo $bats_test_suite_non_existent_dir
  }

  go_to_repository
  readonly moved_dir=$(pwd)
  [ "$moved_dir" = "$current_dir" ]
}
