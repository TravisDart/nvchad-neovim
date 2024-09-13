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
  docker build -t $CONTAINER_NAME --build-arg PYTHON_VERSION=$PYTHON_VERSION .
  
  # Maybe eventually build the "advanced example" container here, as well.
done

# Test local containers
# TODO: Parameterize pytest instead of doing it like this.
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="neovim-image:python$PYTHON_VERSION"
  # Run tests against this container:
  pushd tests/
  CONTAINER_GH_TOKEN=$CONTAINER_GH_TOKEN pytest --local-container-name $CONTAINER_NAME
  popd
  if [ $? -ne 0 ]; then
    ALL_TESTS_PASS=FALSE
  fi
done

if [ $ALL_TESTS_PASS -ne "TRUE" ]; then
   echo "Some tests failed."
   exit 1
else
   echo "All tests pass."
fi

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

echo "All images tested and pushed."

# Pull down the images and test against what's published.
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12 latest)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="travisdart/nvchad-neovim:python$PYTHON_VERSION"
  echo
  echo "Testing $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME

  # The docker command in pytest will pull the container again.
  CONTAINER_GH_TOKEN=$CONTAINER_GH_TOKEN pytest --local-container-name $CONTAINER_NAME
  if [ $? -ne 0 ]; then
    ALL_TESTS_PASS=FALSE
  fi
done

echo "All tests pass."
