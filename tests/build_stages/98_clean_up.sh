#!/bin/bash

# This runs from the project root directory.
cd "$(dirname "$0")"
cd ../..

# Build local containers
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="neovim-image:python$PYTHON_VERSION"
  echo "Removing $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME

  CONTAINER_NAME="neovim-overlay-image:python$PYTHON_VERSION"
  echo
  echo "Removing $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME
done
