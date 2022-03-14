#!/bin/bash

# Given the first and only argument, a string, return the number of characters.
strings.length() {
  local string="$1"
  echo -n "${#string}"
}

# Encode in base64 the given string and send it to STDOUT
strings.base64_encode() {
  local string="$1"
  echo -n "$string" | base64
}

# Decode from base64 the given string and send it to STDOUT
strings.base64_decode() {
  local string="$1"
  echo -n "$string" | base64 --decode
}

# Split string using the specified symbol as a separator. The output returns
# a linte of text with each element separated by a space. Note that while you
# can in theory use a space as a delimiter, there's really not much point in doing it.
strings.split() {
  local string=$1
  local separator=$2
  local IFS=$separator
  # Disable because shellcheck requires the `-r` option, which makes the code fail
  # shellcheck disable=SC2162
  read -a output <<< "$string"
  IFS=''
  echo -n "${output[@]}"
}


# Verify wheter the given string (first argument) starts with the given prefix (second argument).
# Success is given by return value 0.
# Credit for this function goes to https://github.com/dylanaraps/pure-bash-bible#check-if-string-starts-with-sub-string
strings.starts_with() {
  local string=$1
  local prefix=$2

  [[ $string == $prefix* ]]
  return $?
}

# Verify wheter the given string (first argument) ends with the given prefix (second argument).
# Success is given by return value 0.
# Credit for this function goes to https://github.com/dylanaraps/pure-bash-bible#check-if-string-ends-with-sub-string
strings.ends_with() {
  local string=$1
  local prefix=$2

  [[ $string == *$prefix ]]
  return $?
}

# Encodes the given string using URL encoding.
# Credit for this function goes to https://github.com/dylanaraps/pure-bash-bible#split-a-string-on-a-delimiter
strings.url_encode() {
  local string="$1"
  local LC_ALL=C

  for (( i = 0; i < ${#string}; i++ )); do
    local letter="${string:i:1}"
    case "$letter" in
      [a-zA-Z0-9.~_-])
        printf '%s' "$letter"
        ;;
      *)
      printf '%%%02X' "'$letter"
        ;;
    esac
  done
}

# Decodes the url-encoded string.
# Credit for this function goes to https://github.com/dylanaraps/pure-bash-bible#decode-a-percent-encoded-string
strings.url_decode() {
  local string="$1"
  local transformed="${string//+/ }"

  printf '%b' "${transformed//%/\\x}"
}
