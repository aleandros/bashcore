#!/bin/bash

eval "$(bashcore load collections)"

# Provide a way to parse keyword arguments into a hash.
# Earch argument must be provided in the format `key=value`.
functions.parse_keyword_arguments() {
  local hash
  hash=$(collections.hash.new)

  for pair in "$@" ; do
    # Disable because shellcheck requires the `-r` option, which makes the code fail
    # shellcheck disable=SC2162
    read -a split <<< "$(strings.split "$pair" =)"
    # Note that for extracting the second array elemtn we are actually getting
    # all array elements elements except the first one. This is because spaces
    # are the default separator, so if the value contains spaces it would be interpreted
    # as more elements in the array.
    hash=$(collections.hash.add "$hash" "${split[0]}" "${split[*]:1}")
  done

  echo -n "$hash"
}
