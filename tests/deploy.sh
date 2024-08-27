#!/bin/bash

cd "$(dirname "$0")"
cd ..

docker rm neovim
docker rmi neovim-image
docker build -t neovim-image .

docker tag neovim-image travisdart/nvchad-neovim:latest
docker login
docker push travisdart/nvchad-neovim:latest
