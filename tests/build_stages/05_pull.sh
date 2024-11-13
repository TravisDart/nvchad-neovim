#!/bin/bash
source "$(dirname "$0")/00_env.sh"

# Pull down the images so we can test test against what's published.
PYTHON_VERSIONS+=("latest")

for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  CONTAINER_NAME="${PUBLISHED_IMAGE_PREFIX}${PYTHON_VERSION}"
  echo
  echo "Pulling $CONTAINER_NAME"
  docker pull $CONTAINER_NAME
done

echo "All images pulled."

# Now you can go back and run `bash 02_test.sh --published` to test against the published images.
