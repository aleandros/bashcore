# -*- mode: Shell-script;-*-

eval "$(bashcore load validate)"

@test "validate.integer for negative numbers" {
  run validate.integer -3
  [ "$status" = "0" ]
}

@test "validate.integer for positive numbers" {
  run validate.integer 421
  [ "$status" = "0" ]
}

@test "validate.integer for non-leading minus sign" {
  run validate.integer 4-3
  echo "$output"
  [ "$status" = "1" ]
  [ "$output" = "Invalid integer 4-3" ]
}

@test "validate.integer when min is not a valid integer" {
  run validate.integer 3 d
  [ "$status" = "1" ]
  [ "$output" = "Invalid integer d" ]
}

@test "validate.integer when value is less than min" {
  run validate.integer 3 5
  [ "$status" = "1" ]
  [ "$output" = "3 must be greater than or equal to 5" ]
}

@test "validate.integer when value is greater than min" {
  run validate.integer 3 2
  [ "$status" = "0" ]
}

@test "validate.integer when value is equal to min" {
  run validate.integer 3 3
  [ "$status" = "0" ]
}

@test "validate.integer when max is not a valid integer" {
  run validate.integer 3 0 a
  [ "$status" = "1" ]
  [ "$output" = "Invalid integer a" ]
}

@test "validate.integer when value is greater than max" {
  run validate.integer 3 0 1
  [ "$status" = "1" ]
  [ "$output" = "3 must be less than or equal to 1" ]
}

@test "validate.integer when value is less than max" {
  run validate.integer 3 0 4
  [ "$status" = "0" ]
}

@test "validate.integer when value is equal max" {
  run validate.integer 3 0 3
  [ "$status" = "0" ]
}

@test "validate.string when no specification is given" {
  run validate.string "blbl"
  [ "$status" = "0" ]
}

@test "validate.string when no specification is given" {
  run validate.string "blbl"
  [ "$status" = "0" ]
}

@test "validate.string when it passes regex specification" {
  run validate.string "omg" o.{2}
  [ "$status" = "0" ]
}

@test "validate.string when it fails regex specification" {
  run validate.string "omg" o.{3}
  [ "$status" = "1" ]
  [ "$output" = "'omg' does not comply with format 'o.{3}'" ]
}

# ......

@test "validate.float for negative numbers" {
  run validate.float -3
  [ "$status" = "0" ]
}

@test "validate.float for positive numbers" {
  run validate.float 421
  [ "$status" = "0" ]
}

@test "validate.float for negative numbers with decimal point" {
  run validate.float -3.49
  [ "$status" = "0" ]
}

@test "validate.float for positive numbers with decimal point" {
  run validate.float 4.32
  [ "$status" = "0" ]
}

@test "validate.float for non-leading minus sign" {
  run validate.float 4-3
  echo "$output"
  [ "$status" = "1" ]
  [ "$output" = "Invalid float 4-3" ]
}

@test "validate.float for incorrect decimal point" {
  run validate.float 4.4.1
  echo "$output"
  [ "$status" = "1" ]
  [ "$output" = "Invalid float 4.4.1" ]
}

@test "validate.float when min is not a valid float" {
  run validate.float 3 d
  [ "$status" = "1" ]
  [ "$output" = "Invalid float d" ]
}

@test "validate.float when value is less than min" {
  run validate.float 3 5E-1
  [ "$status" = "1" ]
  [ "$output" = "3 must be greater than or equal to 5E-1" ]
}

@test "validate.float when value is greater than min" {
  run validate.float 3 2
  [ "$status" = "0" ]
}

@test "validate.float when value is equal to min" {
  run validate.float 3.1 3.1
  [ "$status" = "0" ]
}

@test "validate.float when max is not a valid float" {
  run validate.float 3 0 a
  [ "$status" = "1" ]
  [ "$output" = "Invalid float a" ]
}

@test "validate.float when value is greater than max" {
  run validate.float 1E10 0 2
  [ "$status" = "1" ]
  [ "$output" = "1E10 must be less than or equal to 2" ]
}

@test "validate.float when value is less than max" {
  run validate.float 3.2E-3 0 4.21
  [ "$status" = "0" ]
}

@test "validate.float when value is equal max" {
  run validate.float 3.1 0 3.1
  [ "$status" = "0" ]
}
