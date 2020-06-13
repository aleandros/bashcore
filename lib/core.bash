#!/bin/bash

# Print the message to STDERR
#
# You can personalize the prefix by providing a variable
# BC_CORE_PREFIX
core.error() {
  local message="$1"
  local prefix="$BC_CORE_PREFIX"

  echo "$prefix$message" >&2
}

# Print message to STDERR and exit with a default status code of 1
core.abort() {
  local message="$1"
  local exit_code="${2:-1}"

  core.error "$message"
  exit "$exit_code"
}

# Verifies that the given program exists and is executable
core.verify_program() {
  which "$1" &>/dev/null
  return $?
}

# Aborts execution if the given executable name is not found
core.ensure_program() {
  local program="$1"

  if ! core.verify_program "$program" ; then
    core.abort "$program not found"
  fi
}

# Creates a temporary directory that will ultimately be removed
# at the end of the script, even if a signal interrupts the program.
#
# The list of directories to remove is stored on the variable
# BC_CORE_INTERNAL_TEMPDIRS, so refrain from modifying it yourself.
#
# The function receives a single argument, which is the variable name
# in which the tempdir path will be stored.
core.make_tempdir() {
  local name="$1"
  local tmp

  tmp="$(mktemp -d)"
  BC_CORE_INTERNAL_TEMPDIRS+=" $tmp"
  trap "exit 1" HUP INT PIPE QUIT TERM
  trap 'rm -rf $BC_CORE_INTERNAL_TEMPDIRS' EXIT
  export "${name}"="$tmp"
}


# Indicates that the given directory does not start with /
BC_CORE_DIRECTORY_NOT_ABSOLUTE=1
# Indicates that the given directory is not present
BC_CORE_DIRECTORY_NOT_FOUND=2
# Indicates that it could not change back to the original directory
BC_CORE_DIRECTORY_FAILED_RETURN=3
# Indicates an error trying to change to target directory
BC_CORE_DIRECTORY_FAILED_CD=3

# Safely executes a given command / function within the given absolute path.
#
# The second argument indicates the variable name for storing the return code
# of the given prog
#
# The third argument is the program and the rest the arguments for the given
# program (or function).
#
# Once executin is finished, returns to the current PWD *before* this function was called.
#
# There can be several sources of errors described in the following constants, which
# will be used as return values. (You can check explanations for each one above).
#
# 1. BC_CORE_DIRECTORY_NOT_ABSOLUTE
# 2. BC_CORE_DIRECTORY_NOT_FOUND
# 3. BC_CORE_DIRECTORY_FAILED_RETURN
# 4. BC_CORE_DIRECTORY_FAILED_CD
#
# After execution, sets the non-local variable BC_CODE_WITHIN_DIRECTORY_RETURN_VALUE with the
# exit status of the given command.
core.within_directory() {
  local target_directory="$1"
  local status_name="$2"
  local program_name="$3"
  local arguments=( "${@:4}" )
  local current_dir="$PWD"


  if ! [ -d "$target_directory" ] ; then
    return "$BC_CORE_DIRECTORY_NOT_FOUND"
  elif [ "${target_directory%${target_directory#?}}" != "/" ] ; then
    return "$BC_CORE_DIRECTORY_NOT_ABSOLUTE"
  fi

  cd "$target_directory" || return "$BC_CORE_DIRECTORY_FAILED_CD"
  "$program_name" "${arguments[@]}"
  export "$status_name=$?"

  cd "$current_dir" || return "$BC_CORE_DIRECTORY_FAILED_RETURN"
}
