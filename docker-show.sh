#!/bin/bash

echo

# Show all images.
CMD="docker image ls"
echo "$CMD"; eval "$CMD";

echo

# Show all containers.
CMD="docker container ls -a"
echo "$CMD"; eval "$CMD";

echo
