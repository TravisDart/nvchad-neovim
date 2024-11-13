#!/bin/bash

cd "$(dirname "$0")"
source 00_env.sh
cd ../..

echo 

if [[ "$@" == "--published" ]]; then
  CONTAINER_PREFIX="travisdart/nvchad-neovim:python"
else
  CONTAINER_PREFIX="neovim-image:python"
fi

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Run the tests -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="${CONTAINER_PREFIX}${PYTHON_VERSION}"
  ADVANCED_EXAMPLE_CONTAINER_NAME="neovim-overlay-image:python$PYTHON_VERSION"

  echo
  echo "Testing $CONTAINER_NAME"

  docker run -it --rm --env CONTAINER_GH_TOKEN=$CONTAINER_GH_TOKEN  \
    -v /var/run/docker.sock:/var/run/docker.sock -v ./tests/:/tests2 neovim-pytest-image \
    pytest \
    --local-container-name $CONTAINER_NAME \
    --advanced-example-container-name $ADVANCED_EXAMPLE_CONTAINER_NAME \
    --git-author-email $GIT_AUTHOR_EMAIL \
    --git-author-name $GIT_AUTHOR_NAME \
    --github-token $GH_TOKEN \
    --workspace-volume-name $WORKSPACE_VOLUME_NAME

  if [ $? -ne 0 ]; then
    ALL_TESTS_PASS=FALSE
  fi
done

if [[ "$ALL_TESTS_PASS" == "TRUE" ]]; then
  echo "All tests pass."
else
  echo "Some tests failed."
  exit 1
fi

# Note that we don't currently clean up any of the containers.
