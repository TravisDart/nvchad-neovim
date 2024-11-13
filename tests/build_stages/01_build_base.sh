#!/bin/bash
source "$(dirname "$0")/00_env.sh"

# Build local containers
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  echo
  echo "Building BUILD_IMAGE_NAME"
  docker build -t BUILD_IMAGE_NAME --build-arg BASE_IMAGE="python:$PYTHON_VERSION-alpine" .
done

