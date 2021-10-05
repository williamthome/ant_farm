#!/bin/bash

# Remember to make it executable by
# chmod u+x ./build.sh

echo "Initial setup..."

mix deps.get --only prod
MIX_ENV=prod mix compile

echo "Compiling assets..."

mix phx.digest

echo "Cleaning up..."

rm -rf "_build"

echo "Releasing..."

MIX_ENV=prod mix release

# echo "Migrating db..."
# MIX_ENV=prod mix ecto.migrate

echo "Done!"