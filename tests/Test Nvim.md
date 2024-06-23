# Full Tests

## Create an example project:

```
mkdir example
cd example
echo "numpy" > requirements.txt
cat <<EOF > example.py
import numpy

numpy.linalg
EOF

export GH_TOKEN='...'
```



## Quickstart:

```
docker run -w /root -it --rm travisdart/nvchad-neovim sh -uelic '
python -m venv /root/workspace_venv
. /root/workspace_venv/bin/activate
pip install numpy
cat <<EOF > example.py
import numpy

numpy.linalg
EOF

nvim example.py
'
```



## Typical Use Case:

```
docker run -w /root/workspace -it --rm --volume .:/root/workspace \
    --env GIT_AUTHOR_EMAIL="you@example.com" \
    --env GIT_AUTHOR_NAME="Your Name" \
    --env GH_TOKEN=$GH_TOKEN \
    travisdart/nvchad-neovim sh -uelic '
     git config --global user.email "$GIT_AUTHOR_EMAIL"
     git config --global user.name "$GIT_AUTHOR_NAME"
     python -m venv /root/workspace_venv
     source /root/workspace_venv/bin/activate
     pip install -r requirements.txt
     nvim
    '

# Test this inside nvim:
# :!echo $GIT_AUTHOR_EMAIL
# :!echo $GIT_AUTHOR_NAME
# :!echo $GH_TOKEN
# :!git config --global user.email
# :!git config --global user.name 
# :!gh auth status
```



## Advanced Use case:

```
cat <<'EOF' > Dockerfile
FROM travisdart/nvchad-neovim:latest

ARG GIT_AUTHOR_EMAIL
ARG GIT_AUTHOR_NAME

RUN if [ -n "$GIT_AUTHOR_EMAIL" ] && [ -n "$GIT_AUTHOR_NAME" ]; then \
    git config --global user.email "$GIT_AUTHOR_EMAIL" && \
    git config --global user.name "$GIT_AUTHOR_NAME" \
    ; \
fi

RUN python -m venv /root/workspace_venv
COPY requirements.txt /root/requirements.txt
RUN /root/workspace_venv/bin/pip install -r /root/requirements.txt

CMD ["/bin/sh", "-c", "source /root/workspace_venv/bin/activate; nvim"]
EOF

docker build --progress=plain -t neovim-image \
    --build-arg GIT_AUTHOR_EMAIL="you@example.com" \
    --build-arg GIT_AUTHOR_NAME="Your Name" \
    .

docker run -it --rm --volume .:/root/workspace \
    -e GH_TOKEN=$GH_TOKEN \
    neovim-image

# Test this for real.
# :!echo $GH_TOKEN
# :!gh auth status
# :!git config --global user.email
# :!git config --global user.name 

cd ..
```

