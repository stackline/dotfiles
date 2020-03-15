#!/usr/bin/env bats

setup() {
  readonly os_name="$(uname)"
  readonly root_directory="$(git rev-parse --show-toplevel)"
  readonly file="$root_directory/.config/profile.d/check_os.sh"
  source $file
}

@test "When OS is Mac, is_mac return success" {
  if [ $os_name != "Darwin" ]; then
    skip
  fi

  run is_mac
  [ "${status}" -eq 0 ]
}

@test "When OS is Mac, is_linux return failure" {
  if [ $os_name != "Darwin" ]; then
    skip "This test only on Mac"
  fi

  run is_linux
  [ "${status}" -eq 1 ]
}

@test "When OS is Linux, is_linux return success" {
  if [ $os_name != "Linux" ]; then
    skip "This test only on Mac"
  fi

  run is_linux
  [ "${status}" -eq 0 ]
}

@test "When OS is Linux, is_mac return failure" {
  if [ $os_name != "Linux" ]; then
    skip "This test only on Linux"
  fi

  run is_mac
  [ "${status}" -eq 1 ]
}
