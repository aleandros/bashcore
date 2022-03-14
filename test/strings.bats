# -*- mode: Shell-script;-*-

eval "$(bashcore load strings)"

@test "strings.length returns the lenght of string" {
  run strings.length "hello world"
  [[ "$output" = "11" ]]
}

@test "strings.base64_decode reverses strings.base64_decode" {
  encoded=$(strings.base64_encode "hi")
  [[ "$encoded" != "hi" ]]
  decoded=$(strings.base64_decode "$encoded")
  [[ "$decoded" = "hi" ]]
}

@test "strings.split separates tokens given symbol" {
 run strings.split a=b=c =
 [[ "$output" = "a b c" ]] 
}

@test "strings.starts_with correctly identifies prefix" {
  run strings.starts_with "hello world, it's me" "hello world"
  [[ "$status" = "0" ]]
}

@test "strings.starts_with returns an error if there is no match" {
  run strings.starts_with "Hello world, it's me" "hello world"
  [[ "$status" = "1" ]]
}

@test "strings.ends_with correctly identifies suffix" {
  run strings.ends_with "hello world, it's me" "it's me"
  [[ "$status" = "0" ]]
}

@test "strings.ends_with returns an error if there is no match" {
  run strings.ends_with "hello world, it's me you are looking for" "it's me"
  [[ "$status" = "1" ]]
}

@test "strings.url_encode encodes string to url" {
  run strings.url_encode "hello world: it's me"
  [[ "$output" = "hello%20world%3A%20it%27s%20me" ]]
}

@test "strings.url_decode decodes the output from strings.url_encode" {
  local encoded=$(strings.url_encode "hello world: it's me")
  run strings.url_decode "$encoded"
  [[ "$output" = "hello world: it's me" ]]
}
