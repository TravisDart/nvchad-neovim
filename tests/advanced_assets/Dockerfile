FROM neovim-image:latest
# FROM travisdart/nvchad-neovim:latest

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
