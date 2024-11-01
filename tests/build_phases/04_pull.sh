#!/bin/bash

cd "$(dirname "$0")"
cd ..

source .env

# Pull down the images so we can test test against what's published.
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12 latest)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="travisdart/nvchad-neovim:python$PYTHON_VERSION"
  echo
  echo "Pulling $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME
  docker pull $CONTAINER_NAME
done

echo "All images pulled."

# Now you can go back and run `bash 02_test.sh --published` to test against the published images.
