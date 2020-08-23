#!/bin/bash

# NOTE: When copying Japanese text with pbcopy in the terminal emulator of Vim,
#       Japanese text is garbled and copied.
function cbcopy() {
  local -r dirname=$(pwd)
  local -r basename="$1"
  local -r input_file="$dirname"/"$basename"

  if [ $# -ne 1 ]; then
    echo "Specify 1 argument." 1>&2
    return 1;
  fi

  if [ ! -f "$input_file" ]; then
    echo "b: File does not exist. \"$input_file\"" 1>&2
    return 1;
  fi

  # ref. https://edvakf.hatenadiary.org/entry/20080929/1222657230
  __CF_USER_TEXT_ENCODING=0x$(printf %x "$(id -u)"):0x08000100:14 pbcopy < "$input_file"

  return 0;
}
