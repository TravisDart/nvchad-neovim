#!/bin/bash

cd "$(dirname "$0")"
source 00_env.sh
cd ../..

if [[ "$@" == "--published" ]]; then
  CONTAINER_PREFIX="travisdart/nvchad-neovim:python"
else
  CONTAINER_PREFIX="neovim-image:python"
fi

# -=-=-=-=-=-=-=-=-=-=-=-=-= Build "advanced example" containers -=-=-=-=-=-=-=-=-=-=
PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  BASE_CONTAINER_NAME="${CONTAINER_PREFIX}${PYTHON_VERSION}"
  CONTAINER_NAME="neovim-overlay-image:python$PYTHON_VERSION"
  echo
  echo "Building $CONTAINER_NAME"
  docker rmi $CONTAINER_NAME

  docker build --no-cache --progress=plain -t $CONTAINER_NAME \
  --build-arg GIT_AUTHOR_EMAIL=$GIT_AUTHOR_EMAIL \
  --build-arg GIT_AUTHOR_NAME=$GIT_AUTHOR_NAME \
  --build-arg BASE_IMAGE=$BASE_CONTAINER_NAME \
  --file ./tests/advanced_example/advanced_example.Dockerfile \
  ./tests/advanced_example/
done

# -=-=-=-=-=-=-=-=-=-=-=-=-= Build the test container and volume -=-=-=-=-=-=-=-=-=-=
docker rmi neovim-pytest-image
docker build -t neovim-pytest-image -f ./tests/pytest.Dockerfile .

# Create a uniquely-named volume containing the example workspace
docker volume create $WORKSPACE_VOLUME_NAME

# We're using the python:3.12-alpine image for this because we will have already pulled that one.
docker run -it --rm -v $WORKSPACE_VOLUME_NAME:/root/workspace \
-w /root/workspace python:3.12-alpine sh -uelic '
echo "numpy" > requirements.txt
echo "import numpy" > example.py
echo >> example.py
echo "numpy.linalg" >> example.py
'
