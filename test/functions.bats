# -*- mode: Shell-script;-*-

eval "$(bashcore load functions)"

@test "functions.parse_keyword_arguments correctly loads values into a hash" {
  args=$(functions.parse_keyword_arguments a=b x=1 c="1 2 3")
  echo "$(collections.hash.get "$args" c)"
  run collections.hash.get "$args" a
  [[ "$output" = b ]]
  run collections.hash.get "$args" x
  [[ "$output" = 1 ]]
  run collections.hash.get "$args" c
  [[ "$output" = "1 2 3" ]]
}
