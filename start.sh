#!/bin/bash

# Remember to make it executable by
# chmod u+x ./start.sh

echo "Starting..."

dir=$(basename "$PWD")
SECRET_KEY_BASE=$(mix phx.gen.secret) _build/prod/rel/$dir/bin/$dir start