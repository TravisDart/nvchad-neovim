#!/bin/bash
source "$(dirname "$0")/00_env.sh"

# -=-=-=-=-=-=-=-=-=-=-=-=-= Build "advanced example" containers -=-=-=-=-=-=-=-=-=-=
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  echo
  echo "Building ADVANCED_TEST_CONTAINER_NAME"
  docker build --no-cache --progress=plain -t ADVANCED_TEST_CONTAINER_NAME \
  --build-arg GIT_AUTHOR_EMAIL=$GIT_AUTHOR_EMAIL \
  --build-arg GIT_AUTHOR_NAME=$GIT_AUTHOR_NAME \
  --build-arg BASE_IMAGE=$BASE_CONTAINER_NAME \
  --file ./tests/advanced_example/advanced_example.Dockerfile \
  ./tests/advanced_example/
done

# -=-=-=-=-=-=-=-=-=-=-=-=-= Build the pytest container -=-=-=-=-=-=-=-=-=-=
docker build -t $PYTEST_CONTAINER_NAME -f ./tests/pytest.Dockerfile .

# -=-=-=-=-=-=-=-=-=-=-=-=-= Build the test volume -=-=-=-=-=-=-=-=-=-=-=-=
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
