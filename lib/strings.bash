#!/bin/bash

# Given the first and only argument, a string, return the number of characters.
strings.length() {
  local string="$1"
  echo -n "$string" | wc -c | awk '{print $1}'
}

# Encode in base64 the given string and send it to STDOUT
strings.base64_encode() {
  local string="$1"
  echo -n "$string" | base64
}

# Decode from base64 the given string and send it to STDOUT
strings.base64_decode() {
  local string="$1"
  echo -n "$string" | base64 --decode
}

