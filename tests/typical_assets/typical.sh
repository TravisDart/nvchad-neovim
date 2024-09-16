#!/bin/bash

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

echo "Remove neovim container, if it exists."
docker rm neovim

docker run -w /root/workspace -it --name neovim --volume .:/root/workspace \
--env GIT_AUTHOR_EMAIL="$LOCAL_GIT_AUTHOR_EMAIL" \
--env GIT_AUTHOR_NAME="$LOCAL_GIT_AUTHOR_NAME" \
--env GH_TOKEN="$GH_TOKEN" \
$CONTAINER_NAME sh -uelic '
git config --global user.email "$GIT_AUTHOR_EMAIL"
git config --global user.name "$GIT_AUTHOR_NAME"
python -m venv /root/workspace_venv
source /root/workspace_venv/bin/activate
pip install -r requirements.txt
nvim
'
