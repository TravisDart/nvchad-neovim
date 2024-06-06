FROM alpine:latest

ARG GIT_CONFIG_EMAIL
ARG GIT_CONFIG_NAME

RUN apk add --no-cache git nodejs neovim ripgrep build-base curl \
    stylua \
    python3 py3-lsp-server py3-isort black \
    github-cli \
    --update

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ lua-language-server

# Check if build args are provided, otherwise exit
RUN if [ -z "$GIT_CONFIG_EMAIL" ] || [ -z "$GIT_CONFIG_NAME" ]; then \
    echo "ERROR: Missing build arguments GIT_CONFIG_EMAIL and GIT_CONFIG_NAME"; \
    exit 1; \
fi

RUN git config --global user.email "$GIT_CONFIG_EMAIL" && \
    git config --global user.name "$GIT_CONFIG_NAME"

RUN mkdir -p /root/.config/nvim
COPY . /root/.config/nvim

RUN nvim --headless +"Lazy! sync" +"Lazy! load nvim-treesitter" \
    +"TSInstallSync vim lua vimdoc markdown json yaml toml html css javascript typescript python" \
    +qa!

ENTRYPOINT ["nvim"]
