#!/bin/bash
source "$(dirname "$0")/00_env.sh"

# Tag the last Python image as latest.
LATEST_IMAGE_NAME=$(echo $BUILD_IMAGE_PREFIX | sed 's/:python.*$/:latest/')
LAST_VERSION_IMAGE_NAME="${BUILD_IMAGE_PREFIX}${PYTHON_VERSIONS[-1]}"
docker tag $LAST_VERSION_IMAGE_NAME $LATEST_IMAGE_NAME

# Tag and push the images
PYTHON_VERSIONS+=("latest")
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  LOCAL_IMAGE_NAME="${BUILD_IMAGE_PREFIX}${PYTHON_VERSION}"
  REMOTE_IMAGE_NAME="${PUBLISHED_IMAGE_PREFIX}${PYTHON_VERSION}"
  docker tag $LOCAL_IMAGE_NAME $REMOTE_IMAGE_NAME
  docker push $REMOTE_IMAGE_NAME
done

echo "All images pushed."
