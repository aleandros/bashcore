# -*- mode: Shell-script;-*-

eval "$(bashcore load collections)"

@test "collections.hash.new creates a new structure with the CREATE event" {
  run collections.hash.new
  [[ "$output" =~ ^ENCODED_HASH ]]
}

@test "collections.hash.new accepts a single argument, but fails if unrecognized" {
  run collections.hash.new bad-argument
  echo "$output"
  [ -z "$output" ]
  [ "$status" = "1" ]
}

@test "collections.hash.new accepts the option for skiping encoding, and stores it in the header" {
  run collections.hash.new --skip-encoding
  [[ "$output" =~ ^PLAIN_HASH ]]
}

@test "collections.hash.size returns the number of entries in the hash" {
}

@test "collections.hash.remove eliminates key" {
  my_hash=$(collections.hash.new)
  my_hash=$(collections.hash.add "$my_hash" x 1)
  my_hash=$(collections.hash.remove "$my_hash" x)
  run collections.hash.get "$my_hash" x
  [ -z "$output" ]
  [ "$status" = "1" ]
}

@test "collections.hash.get checks for the latest version of the ADD event" {
  my_hash=$(collections.hash.new)
  my_hash=$(collections.hash.add "$my_hash" x 1)
  my_hash=$(collections.hash.add "$my_hash" x 2)
  run collections.hash.get "$my_hash" x
  [ "$output" = "2" ]
  [ "$status" = "0" ]
}

@test "collections.hash.add succeds for plain hashes when keys and values are correct" {
  my_hash=$(collections.hash.new --skip-encoding)
  run collections.hash.add "$my_hash" hello world
  [ "$status" = "0" ]
}

@test "collections.hash.add fails for plain hashes when key has a delimiter" {
  my_hash=$(collections.hash.new --skip-encoding)
  run collections.hash.add "$my_hash" hello: world
  [ -z "$output" ]
  [ "$status" = "1" ]
}

@test "collections.hash.add fails for plain hashes when value has delimiter" {
  my_hash=$(collections.hash.new --skip-encoding)
  run collections.hash.add "$my_hash" hello world:
  [ -z "$output" ]
  [ "$status" = "1" ]
}

@test "collections.hash.add fails for even number of arguments" {
  skip
  my_hash=$(collections.hash.new --skip-encoding)
}

@test "collections.hash.add allows adding several hash entries at once" {
  skip
}

@test "collections.hash.get returns non-zero status if key is not found" {
  my_hash=$(collections.hash.new)
  my_hash=$(collections.hash.add "$my_hash" x 1)
  echo "$my_hash"
  my_hash=$(collections.hash.remove "$my_hash" x)
  echo "$my_hash"
  run collections.hash.get "$my_hash" x
  [ -z "$output" ]
  [ "$status" = "1" ]
}

@test "collections.hash.get returns non-zero status if latest status is REMOVE" {
  my_hash=$(collections.hash.new)
  my_hash=$(collections.hash.add "$my_hash" x 1)
  run collections.hash.get "$my_hash" y
  [ -z "$output" ]
  [ "$status" = "1" ]
}

@test "collections.hash.get works with whitespace in keys and values" {
  my_hash=$(collections.hash.new)
  my_hash=$(collections.hash.add "$my_hash" "oh no" "oh yes")
  run collections.hash.get "$my_hash" "oh no"
  [ "$output" = "oh yes" ]
  [ "$status" = "0" ]
}

@test "collections.hash.get works with delimiters in keys and values" {
  my_hash=$(collections.hash.new)
  my_hash=$(collections.hash.add "$my_hash" "oh: no" "oh: yes")
  run collections.hash.get "$my_hash" "oh: no"
  [ "$output" = "oh: yes" ]
  [ "$status" = "0" ]
}

@test "collections.hash.get works with empty values" {
  my_hash=$(collections.hash.new)
  my_hash=$(collections.hash.add "$my_hash" x "")
  run collections.hash.get "$my_hash" x
  [ "$output" = "" ]
  [ "$status" = "0" ]
}

@test "collections.hash.get can handle nested hashes" {
  outer_hash=$(collections.hash.new)
  inner_hash=$(collections.hash.new)
  inner_hash=$(collections.hash.add "$inner_hash" x "testing nested value")
  outer_hash=$(collections.hash.add "$outer_hash" inner "$inner_hash")
  inner_copy=$(collections.hash.get "$outer_hash" inner)
  run collections.hash.get "$inner_copy" x
  [ "$output" = "testing nested value" ]
}
