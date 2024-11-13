#!/bin/bash
source "$(dirname "$0")/00_env.sh"

echo "Cleaning up... (Ignore any errors.)"

docker stop $(docker ps | grep $DOCKER_PREFIX | awk '{print $1}') 2>/dev/null > /dev/null
docker rm $(docker ps -a | grep $DOCKER_PREFIX | awk '{print $1}') 2>/dev/null > /dev/null

for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  docker image rm "$PUBLISHED_IMAGE_PREFIX:$PYTHON_VERSION" 2>/dev/null > /dev/null
done
docker image rm "$PUBLISHED_IMAGE_PREFIX:latest" 2>/dev/null > /dev/null

docker image rm $(docker images | grep $DOCKER_PREFIX | awk '{print $3}') 2>/dev/null > /dev/null
docker volume rm $WORKSPACE_VOLUME_NAME 2>/dev/null > /dev/null
