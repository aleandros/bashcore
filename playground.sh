#!/bin/bash

export PATH=".:$PATH"
eval "$(bashcore load)"

benchmark.bench args.add_flag --help STRING "This is the data"

# args.usage

# args.add_arg       status    STRING
# args.add_multi_arg stuff

# args.parse

# if args.has_flag --help ; then
#   args.usage
#   exit
# fi

# if args.has_flag --tmpdir ; then
#   tmpdir=$(ars.flag_value --tmpdir)
# fi

# args.argument status
