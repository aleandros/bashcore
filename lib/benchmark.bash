#!/bin/bash

# benchmark.average() {
#   :
# }

# benchmark.min() {
#   :
# }

# benchmark.max() {
#   :
# }

benchmark.bench() {
  local program=$1
  local args=${*:1}

  for _ in {1..10} ; do
    # shellcheck disable=SC2086
    time $program $args
  done
}
