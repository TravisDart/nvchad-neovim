#!/bin/bash

# This runs from the project root directory.
cd "$(dirname "$0")"
cd ../..

# Build local containers
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="neovim-image:python$PYTHON_VERSION"
  echo
  echo "Building $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME
  docker build -t $CONTAINER_NAME --build-arg BASE_IMAGE="python:$PYTHON_VERSION-alpine" .
done
