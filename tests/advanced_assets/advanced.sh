#!/bin/bash

# This script is for manual testing and isn't called by pytest.

cd "$(dirname "$0")"

if [[ -z "$1" ]]; then
    CONTAINER_NAME="travisdart/nvchad-neovim"
else
    CONTAINER_NAME="$1"
fi

if [[ -z "$2" ]]; then
    GH_TOKEN="none"
else
    GH_TOKEN="$2"
fi


if [[ -z "$3" ]]; then
    LOCAL_GIT_AUTHOR_EMAIL="you@example.com"
else
    LOCAL_GIT_AUTHOR_EMAIL="$3"
fi


if [[ -z "$4" ]]; then
    LOCAL_GIT_AUTHOR_NAME="Your Name"
else
    LOCAL_GIT_AUTHOR_NAME="$4"
fi

docker build --no-cache --progress=plain -t neovim-overlay-image \
    --build-arg GIT_AUTHOR_EMAIL="$LOCAL_GIT_AUTHOR_EMAIL" \
    --build-arg GIT_AUTHOR_NAME="$LOCAL_GIT_AUTHOR_NAME" \
    .

docker run -it --rm --volume .:/root/workspace \
    -e GH_TOKEN="$GH_TOKEN" \
    neovim-overlay-image

# Things to test:
# Test the normal autocomplete
# :!echo $GH_TOKEN
# :!gh auth status
# :!git config --global user.email
# :!git config --global user.name 

# Clean up afterwords:
docker rmi neovim-overlay-image
