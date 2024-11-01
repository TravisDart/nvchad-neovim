#!/bin/bash

cd "$(dirname "$0")"
cd ..

source .env

# Build local containers
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="neovim-image:python$PYTHON_VERSION"
  echo
  echo "Building $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME
  docker build -t $CONTAINER_NAME --build-arg BASE_IMAGE="python:$PYTHON_VERSION-alpine" .
  
  # Maybe eventually build the "advanced example" container here, as well.
done

# Build "advanced example" containers here, as well.
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="neovim-overlay-image:python$PYTHON_VERSION"
  BASE_CONTAINER_NAME="neovim-image:python$PYTHON_VERSION"
  echo
  echo "Building $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME

  docker build --no-cache --progress=plain -t $CONTAINER_NAME \
  --build-arg GIT_AUTHOR_EMAIL="{git_email_address}" \
  --build-arg GIT_AUTHOR_NAME="{git_username}" \
  --build-arg BASE_IMAGE=$BASE_CONTAINER_NAME \
  {asset_directory}
done



