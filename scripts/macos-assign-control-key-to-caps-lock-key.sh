#!/bin/bash

# ### plist for managing global domains
#
# * /Users/<User name>/Library/Preferences/ByHost/.GlobalPreferences.<Any code>.plist
#
# ### How to edit plist with plutil
#
# ```
# $ plutil -p any.plist
# $ plutil -convert xml1 any.plist
# $ vi any.plist
# $ plutil -convert binary1 any.plist
# $ plutil -p any.plist
# ```

function get_internal_keyboard_modifiermapping_domain() {
  local -r properties="$(ioreg -p IOUSB -n 'Apple Internal Keyboard / Trackpad' -r)"
  local -r id_vendor="$(echo "$properties" | grep idVendor | awk '{ print $NF }')"
  local -r id_product="$(echo "$properties" | grep idProduct | awk '{ print $NF }')"
  local -r keyboard_id="$id_vendor-$id_product-0"
  echo "com.apple.keyboard.modifiermapping.$keyboard_id"
}

# NOTE: In the following plist, values are set as string type.
#
#   echo "{ HIDKeyboardModifierMappingDst = 30064771300; HIDKeyboardModifierMappingSrc = 30064771129; }"
#
# If the values are not integer type, the settings are not reflected.
# Therefore, it is created in xml format.
function create_internal_keyboard_modifiermapping_plist() {
  local -r CAPS_LOCK_KEY=30064771300
  local -r CONTROL_KEY=30064771129
  echo "<dict>
  <key>HIDKeyboardModifierMappingDst</key>
  <integer>$CAPS_LOCK_KEY</integer>
  <key>HIDKeyboardModifierMappingSrc</key>
  <integer>$CONTROL_KEY</integer>
</dict>"
}

function read_defaults_for_domain() {
  local -r domain=$1
  defaults -currentHost read -g "$domain"
}

function overwrite_defaults_in_domain() {
  local -r domain=$1
  local -r plist=$2
  defaults -currentHost write -g "$domain" -array "$plist"
}

function main() {
  local -r domain="$(get_internal_keyboard_modifiermapping_domain)"
  local -r plist="$(create_internal_keyboard_modifiermapping_plist)"

  echo "==> Domain"
  echo "$domain"
  echo

  echo "==> plist"
  echo "$plist"
  echo

  echo "==> Defaults for domain"
  read_defaults_for_domain "$domain"
  echo

  echo "==> Change settings..."
  overwrite_defaults_in_domain "$domain" "$plist"
  echo

  echo "==> Defaults for domain"
  read_defaults_for_domain "$domain"
}

main
