#!/bin/bash

cd "$(dirname "$0")"
cd ..

source .env

docker rmi neovim-pytest-image
docker build -t neovim-pytest-image -f ./tests/pytest.Dockerfile .

# Pull down the images and test against what's published.
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12 latest)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  echo
  echo "Testing $CONTAINER_NAME"

  if [[ "$@" == "--published" ]]; then
    CONTAINER_NAME="travisdart/nvchad-neovim:python$PYTHON_VERSION"
  else
    CONTAINER_NAME="neovim-image:python$PYTHON_VERSION"
  fi
  ADVANCED_EXAMPLE_CONTAINER_NAME="neovim-overlay-image:python$PYTHON_VERSION"

  docker run -it --rm --env CONTAINER_GH_TOKEN=$CONTAINER_GH_TOKEN  \
    -v /var/run/docker.sock:/var/run/docker.sock -v ./tests/:/tests2 neovim-pytest-image \
    pytest \
    --local-container-name $CONTAINER_NAME \
    --advanced-example-container-name $ADVANCED_EXAMPLE_CONTAINER_NAME
 
  if [ $? -ne 0 ]; then
    ALL_TESTS_PASS=FALSE
  fi
done

echo "All tests pass."
