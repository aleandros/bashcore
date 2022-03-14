#!/bin/bash

eval "$(bashcore load strings)"

# Default field delimiter for every entry in a collection.
BC_COLLECTIONS_FIELD_DELIMITER=":"
# Default entry delimiter for separating elements in a collection.
BC_COLLECTIONS_ENTRY_DELIMITER="@"

# Creates a new hash value. Note that hashes are internally stored using
# a simple text based representation (which is directly serializable to disk
# if necessary).
#
# Since hashes are strings, all operations are immutable, always returning
# a new strings containing the hash.
#
# The reasoning behind creating this is making an easy-to-use associative array
# compatible with bash 3 (which is installed by default in Mac OS X).
#
# Of course, this will not win any performance contests so please use it for relatively
# small number (in the order of 100s) of elments.
#
# Due to performance considerations, you can pass a single argument, `--skip-encoding`.
# If you supply such argument, the hash does not uses encoding for storing keys and values,
# which makes it faster but will fail if adding a value or key that contains
# any of the delimiters when adding new entries.
collections.hash.new() {
  local option=$1

  if [ -z "$option" ] ; then
    echo -n "ENCODED_HASH"
  elif [ "$option" = "--skip-encoding" ] ; then
    echo -n "PLAIN_HASH"
  else
    return 1
  fi
}

# Adds a new element to the given hash, given the original hash,
# a key and a value. If the element already existed, it simply replaces it.
#
# For the sake of clarification, remember that all operations return a new hash.
collections.hash.add() {
  local hash=$1
  local key=$2
  local value=$3
  local encoded_key

  if collections.hash._is_encoded "$hash" ; then
    encoded_key=$(strings.url_encode "$key")
    encoded_value=$(strings.url_encode "$value")
  elif [[ "$key" =~ [$BC_COLLECTIONS_ENTRY_DELIMITER$BC_COLLECTIONS_FIELD_DELIMITER] ]] || \
       [[ "$value" =~ [$BC_COLLECTIONS_ENTRY_DELIMITER$BC_COLLECTIONS_FIELD_DELIMITER] ]] ; then
    return 1
  else
    encoded_key=$key
    encoded_value=$value
  fi

  printf "%s%s" "$hash" "$BC_COLLECTIONS_ENTRY_DELIMITER"
  printf "ENTRY%s%s%s%s%s" \
         "$BC_COLLECTIONS_FIELD_DELIMITER" \
         "$encoded_key" \
         "$BC_COLLECTIONS_FIELD_DELIMITER" \
         "$encoded_value" \
         "$BC_COLLECTIONS_ENTRY_DELIMITER"
}

# Removes the given key from the hash, returning a new one.
collections.hash.remove() {
  local hash=$1
  local key=$2
  local target

  target=$(collections.hash._search_target "$hash" "$key")

  echo "$hash" | tr "$BC_COLLECTIONS_ENTRY_DELIMITER" "\n" | grep -v "$target"
}

# Given a hash and a key, get the associated value.
#
# If the value could not be found, it returns an exit status code
# of 1. Note that is better to rely on the status code instead
# of the empty result for checking the existance of a given key,
# since a value can be an empty string.
collections.hash.get() {
  local hash=$1
  local key=$2
  local return_code=1
  local target
  local found_entry

  target=$(collections.hash._search_target "$hash" "$key")
  found_entry="$(echo -n "$hash" | tr "$BC_COLLECTIONS_ENTRY_DELIMITER" "\n" |grep "$target" | tail -n 1)"

  if [ -n "$found_entry" ] ; then
    strings.url_decode "${found_entry#$target}"
    return_code=0
  fi

  return $return_code
}

# Given a hash, stream to STDOUT key-value pairs, one per line,
# with the key separated from the value via space.
#
# Beware that this function only will work correctly if both keys and values
# contain no whitespace.
collections.hash.iterate() {
  local hash=$1

  return 0  
}

collections.hash._search_target() {
  local hash=$1
  local key=$2
  local encoded_key

  if collections.hash._is_encoded "$hash" ; then
    encoded_key=$(strings.url_encode "$key")
  else
    encoded_key=$key
  fi

  echo -n "ENTRY$BC_COLLECTIONS_FIELD_DELIMITER$encoded_key$BC_COLLECTIONS_FIELD_DELIMITER"
}

collections.hash._is_encoded() {
  local hash=$1
  if strings.starts_with "$hash" ENCODED_HASH ; then
    return 0
  else
    return 1
  fi
}
