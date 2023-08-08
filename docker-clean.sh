#!/bin/bash

echo

# Find unused images and remove them.
CMD="docker image ls -f dangling=true -q | xargs -L 1 -r docker image rm "
echo "$CMD"; eval "$CMD";

echo

# Find unused volumes and remove them.
CMD="docker volume ls -f dangling=true -q | xargs -L 1 -r docker volume rm "
echo "$CMD"; eval "$CMD";

echo
