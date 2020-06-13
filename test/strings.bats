# -*- mode: Shell-script;-*-

eval "$(bashcore load strings)"

@test "strings.length returns the lenght of string" {
  run strings.length "hello world"
  [ "$output" = "11" ]
}

@test "strings.base64_decode reverses strings.base64_decode" {
  encoded=$(strings.base64_encode "hi")
  [ "$encoded" != "hi" ]
  decoded=$(strings.base64_decode "$encoded")
  [ "$decoded" = "hi" ]
}
