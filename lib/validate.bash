#!/bin/bash

eval "$(bashcore load core)"

# Ensures that the value is a valid positive/negative integer,
# optionally ensuring that is greater than or equal than the second
# argument, and less than or equal to the third argument.
validate.integer() {
  local target="$1"
  local min="$2"
  local max="$3"

  if ! [[ "$target" =~ ^\-?[0-9]+$ ]] ; then
    core.error "Invalid integer $target"
    return 1
  fi

  if [ -n "$min" ] ; then
    if ! validate.integer "$min" ; then
      return 1
    fi
    if ! [ "$target" -ge "$min" ] ; then
      core.error "$target must be greater than or equal to $min"
      return 1
    fi
  fi

  if [ -n "$max" ] ; then
    if ! validate.integer "$max" ; then
      return 1
    fi
    if ! [ "$target" -le "$max" ] ; then
      core.error "$target must be less than or equal to $max"
      return 1
    fi
  fi
}

# Ensures that the value is a valid floating point number,
# optionally ensuring that is greater than or equal than the second
# argument, and less than or equal to the third argument.
#
# Note that comparison is fed to the `bc` program, so it accepts exponent notation
# using an uppercase letter E.
validate.float() {
  local target="$1"
  local min="$2"
  local max="$3"

  if ! [[ "$target" =~ ^\-?[0-9]+(\.[0-9]+)?(E\-?[0-9]+)?$ ]] ; then
    core.error "Invalid float $target"
    return 1
  fi

  if [ -n "$min" ] ; then
    if ! validate.float "$min" ; then
      return 1
    fi
    if [ "$(echo "$target >= $min" | bc -l)" = "0" ]; then
      core.error "$target must be greater than or equal to $min"
      return 1
    fi
  fi

  if [ -n "$max" ] ; then
    if ! validate.float "$max" ; then
      return 1
    fi
    if [ "$(echo "$target <= $max" | bc -l)" = "0" ]; then
      core.error "$target must be less than or equal to $max"
      return 1
    fi
  fi
}

# Validates that the first argument is a string that complies with a regex
# specified in the second argument. If no second argument is given, this
# funciton is always successful.
validate.string() {
  local target="$1"
  local format="$2"

  if [ -n "$format" ] ; then
    if ! [[ "$target" =~ $format ]] ; then
      core.error "'$target' does not comply with format '$format'"
      return 1
    fi
  fi
}
