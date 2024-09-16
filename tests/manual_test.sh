#!/bin/bash

# $CONTAINER_GH_TOKEN must be set outside of this file.

docker rmi travisdart/nvchad-neovim:latest

docker run -w /root -it --rm travisdart/nvchad-neovim:latest sh -uelic '
python -m venv /root/workspace_venv
. /root/workspace_venv/bin/activate
cat <<EOF > example.py
import time
time
EOF
nvim example.py
'

docker run -w /root -it --rm travisdart/nvchad-neovim:latest sh -uelic '
python -m venv /root/workspace_venv
. /root/workspace_venv/bin/activate
pip install numpy
cat <<EOF > example.py
import numpy
numpy.linalg
EOF
nvim example.py
'

bash tests/typical_assets/typical.sh travisdart/nvchad-neovim:latest $CONTAINER_GH_TOKEN asdf@example.com fdsa

# Note that you'll need to change the Dockerfile to the non-local image name.
bash tests/advanced_assets/advanced.sh travisdart/nvchad-neovim:latest $CONTAINER_GH_TOKEN asdf@example.com fdsa
