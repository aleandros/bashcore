# -*- mode: Shell-script;-*-

eval "$(bashcore load system)"

@test "system.platform returns a value" {
  run system.platform
  [ "$status" = "0" ]
  [ ! -z "$output" ]
}

@test "system.processor_count returns an integer" {
  run system.processor_c
  [[ "$output" =~ \d+ ]]
}
