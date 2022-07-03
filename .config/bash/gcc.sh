#!/bin/bash

# C++ source code compile and execution
function g++run() {
  local -r dirname=$(pwd)
  local -r basename="$1"
  local -r input_file="$dirname"/"$basename"
  local -r output_file="$dirname"/a.out

  if [ $# -ne 1 ]; then
    echo "Specify 1 argument." 1>&2
    return 1;
  fi

  if [ ! -f "$input_file" ]; then
    echo "b: File does not exist. \"$input_file\"" 1>&2
    return 1;
  fi

  # -std=gnu++17       Conform to the ISO 2017 C++ standard with GNU extensions.
  # -Wall              Enable most warning messages.
  # -Wextra            Print extra (possibly unwanted) warnings.
  # -O<number>         Set optimization level to <number>.
  # -D<macro>[=<val>]  Define a <macro> with <val> as its value.
  #                    If just <macro> is given, <val> is taken to be 1.
  #
  # ref. https://atcoder.jp/contests/language-test-202001
  #
  "${HOMEBREW_PREFIX}"/bin/g++-9 -std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -o "$output_file" "$input_file"

  echo "### output"
  if ! "$output_file"; then
    echo "b: Runtime Error" 1>&2
    rm -f "$output_file"
    return 1;
  fi

  rm -f "$output_file"
  return 0;
}
