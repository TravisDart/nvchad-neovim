#!/bin/bash

cd "$(dirname "$0")"
cd ..

source .env

# Tag the last image as latest.
docker tag $CONTAINER_NAME "neovim-image:latest"

# Tag and push the images
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12 latest)
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  LOCAL_CONTAINER_NAME="neovim-image:python$PYTHON_VERSION"
  REMOTE_CONTAINER_NAME="travisdart/nvchad-neovim:python$PYTHON_VERSION"
  docker tag $LOCAL_CONTAINER_NAME $REMOTE_CONTAINER_NAME
  docker push $REMOTE_CONTAINER_NAME
done

echo "All images pushed."
