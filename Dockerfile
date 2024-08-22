FROM alpine:latest

ARG GIT_AUTHOR_EMAIL
ARG GIT_AUTHOR_NAME

RUN apk add --no-cache git nodejs neovim neovim-doc ripgrep build-base curl \
    stylua  \
    python3 py3-lsp-server py3-isort black \
    github-cli \
    --update

# (These packages are not yet available in the main repositry.) 
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ lua-language-server luarocks

# Check if both build args are provided, otherwise don't configure git.
RUN if [ -n "$GIT_AUTHOR_EMAIL" ] && [ -n "$GIT_AUTHOR_NAME" ]; then \
    git config --global user.email "$GIT_AUTHOR_EMAIL" && \
    git config --global user.name "$GIT_AUTHOR_NAME" \
    ; \
fi

RUN mkdir -p /root/.config/nvim
COPY . /root/.config/nvim

# Currently gives "nvim-treesitter[vim]: Error during compilation", but this can be ignored.
RUN nvim --headless +"Lazy! sync" +"Lazy! load nvim-treesitter" \
    +"TSInstallSync! vim lua vimdoc markdown json yaml toml html css javascript typescript python" \
    +qa!

WORKDIR /root/workspace
CMD ["nvim"]
