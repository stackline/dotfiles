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
}

@test "Write warning message to stdout" {
  source "${test_target_file}"
  source "${mock_function_file}"

  run mock_function
  [ "$status" -eq 0 ]
  [[ "$output" =~ "(mock.sh:2) warning: any warning message" ]]
}
