#!/usr/bin/env bats

function setup() {
  readonly test_target_file="$(git rev-parse --show-toplevel)/.config/bash/debug.sh"
  readonly bats_test_suite_tmpdir="$(pwd)/bats-test-tmp"
  readonly mock_function_file="${bats_test_suite_tmpdir}/mock.sh"

  mkdir -p "${bats_test_suite_tmpdir}"
  cat <<EOL > ${mock_function_file}
    function mock_function() {
      debug::warn 'any warning message'
    }
EOL
}

function teardown() {
  rm -rf "${bats_test_suite_tmpdir}"
  unset CURRENT_SHELL
}

@test "When current shell is bash, write warning message to stdout" {
  CURRENT_SHELL='bash'
  source "${test_target_file}"
  source "${mock_function_file}"

  run mock_function
  [ "$status" -eq 0 ]
  [[ "$output" =~ "(mock.sh:2) warning: any warning message" ]]
}

@test "When current shell is zsh, write warning message to stdout" {
  # NOTE: Bats is Bash automated testing system.
  #       Prepare dummy Zsh parameter for testing.
  local -r funcfiletrace=(/foo/bar/baz.sh:10 ${mock_function_file}:2)

  CURRENT_SHELL='zsh'
  source "${test_target_file}"
  source "${mock_function_file}"

  run mock_function
  [ "$status" -eq 0 ]
  echo $output
  [[ "$output" =~ "(mock.sh:2) warning: any warning message" ]]
}

@test "When current shell is not bash and zsh, write warning message to stdout" {
  CURRENT_SHELL='fish'

  run source "${test_target_file}"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "(debug.sh) warning: CURRENT_SHELL is 'fish'. debug.sh only supports Bash and Zsh." ]]
}
