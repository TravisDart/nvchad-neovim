#!/bin/bash

if [[ -z "$1" ]]; then
    CONTAINER_NAME="travisdart/nvchad-neovim"
else
    CONTAINER_NAME="$1"
fi

docker run -w /root -it --rm $CONTAINER_NAME sh -uelic '
python -m venv /root/workspace_venv
. /root/workspace_venv/bin/activate
pip install numpy
cat <<EOF > example.py
import numpy

numpy.linalg
EOF

nvim example.py
'
