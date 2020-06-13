# -*- mode: Shell-script;-*-

eval "$(bashcore load core)"

@test "core.error displays message to STDERR" {
  run core.error Example
  [ "$output" = "Example" ]
}

@test "core.error uses the BC_CORE_PREFIX variable" {
  BC_CORE_PREFIX="[UwU] "
  run core.error "My message"
  [ "$output" = "[UwU] My message" ]
}

@test "core.abort exists program with a default status of 1" {
  run core.abort "Error!"
  [ "$status" = "1" ]
  [ "$output" = "Error!" ]
}

@test "core.abort allows overriding status code" {
  run core.abort "Error!" 3
  [ "$status" = "3" ]
}

@test "core.verify_program when program exists" {
  run core.verify_program bash
  [ "$status" = "0" ]
  [ -z "$output" ]
}

@test "core.verify_program when program does not exist" {
  run core.verify_program this-should-not-exists
  [ "$status" != "0" ]
  [ -z "$output" ]
}

@test "core.ensure_program when program exists" {
  run core.ensure_program bash
  [ "$status" = "0" ]
  [ -z "$output" ]
}

@test "core.ensure_program when program does not exist" {
  run core.ensure_program this-should-not-exists
  [ "$status" = "1" ]
  [ "$output" = "this-should-not-exists not found" ]
}

@test "core.make_tempdir stores the path in the given variable" {
  core.make_tempdir my_tmpdir
  [ -d "$my_tmpdir" ]
}

@test "core.within_directory fails for non-absolute directories" {
  run core.within_directory . INNER_STATUS ls -la
  [ "$status" = "$BC_CORE_DIRECTORY_NOT_ABSOLUTE" ]
}

@test "core.within_directory fails for non-existing directories" {
  run core.within_directory . INNER_STATUS ls -la
  [ "$status" = "$BC_CORE_DIRECTORY_NOT_ABSOLUTE" ]
}

within_directory_sample() {
  echo "$(pwd): $1"
  return 52
}

@test "core.within_directory executes inside given directory" {
  local target_dir="$PWD/lib"
  run core.within_directory "$target_dir" exit_code \
      within_directory_sample 'Testing'
  [ "$output" = "${target_dir}: Testing" ]
  [ "$PWD" != "$target_dir" ]
}
