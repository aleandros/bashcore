#!/bin/bash

eval "$(bashcore load core)"
eval "$(bashcore load collections)"
declare BC_ARGS_HASH

args.init_args_hash() {
  if [ -z "$BC_ARGS_HASH" ] ; then
    BC_ARGS_HASH=$(collections.hash.new --skip-encode)
    BC_ARGS_HASH=$(collections.hash.add "$BC_ARGS_HASH" loading "")
  fi
  # elif [ -n "$(collections.hash.get "$BC_ARGS_HASH" loading)" ] ; then
  #   core.abort "Attempting to modify arguments description after parsing values"
  # fi
}

args.set_description() {
  local description=$1
  args.init_args_hash
  BC_ARGS_HASH=$(collections.hash.add "$BC_ARGS_HASH" description "$description")
}

args.set_version() {
  local version=$1
  args.init_args_hash
  BC_ARGS_HASH=$(collections.hash.add "$BC_ARGS_HASH" version "$version")
}

args.description() {
  collections.hash.get "$BC_ARGS_HASH" description
}

args.version() {
  collections.hash.get "$BC_ARGS_HASH" version
}

args.add_flag() {
  local flag_pattern=$1
  local data_type
  local description
  local flag

  args.init_args_hash

  if [ $# -eq 2 ] ; then
    data_type=BOOLEAN
    description=$2
  elif [ $# -eq 3 ] ; then
    data_type=$2
    description=$3
  fi

  flag=$(collections.hash.new)
  flag=$(collections.hash.add "$flag" pattern "$flag_pattern")
  flag=$(collections.hash.add "$flag" description "$description")
  flag=$(collections.hash.add "$flag" data_type "$data_type")

  BC_ARGS_HASH=$(collections.hash.add "$BC_ARGS_HASH" "$flag_pattern" "$flag")
}

args.usage() {
  args.description
  args.version
}
