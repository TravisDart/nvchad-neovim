# Neovim (nvChad) Docker Container

This is a turnkey Python IDE using Neovim and Docker. With this container, setting up Vim is one Docker command, instead of requiring manual configuration and setup.

Containerizing Neovim streamlines the Neovim setup process and lowers the bar to entry for new users. It also opens new possibilities beyond the traditional use cases. For example, using this container with virtual machines or Kubernetes, you can create many simultaneous development environments for multiple branches, similar to a self-hosted GitHub Codespaces. Or, you can streamline developer onboarding by including a containerized "reference IDE".



## Quickstart:

Run this command to create a minimal Python project and start Neovim:

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

Once Vim launches, the example file provides a sandbox to try features such as Python autocomplete/formatting and features from nvChad. This is similar to the Docker-based preview in the [nvChad documentation](https://nvchad.com/docs/quickstart/install#install), but there aren't any IDE features enabled with the default nvChad configuration. Also note that nvChad makes you wait for plugins to install on the first start, while this container loads plugins at buildtime, rather than runtime.



## Typical Use Case:

To use with an existing Python project, start the Neovim container in the root directory of your project using the command below. Your project will be mounted in the `/root/workspace` directory inside the container. Before Neovim starts, you can also install any external Python dependencies. - Neovim needs to reference your external dependencies for features such as autocomplete, so project dependencies must be added to the Neovim container.

```
cd your_project

docker run -w /root/workspace -it --name neovim --volume .:/root/workspace \
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
```

Note: In general, you can't create a virtual environment on the host, then activate it from the container. This would require creating the virtual environment using relative links, which are [not supported on MacOS](https://github.com/pyenv/pyenv-virtualenv/pull/433). But, on some platforms this could theoretically be possible, and it would be pretty convenient in certain cases.

Optional Features:

* **GitHub Integration:** The GitHub CLI (`gh` command) is included in the container. Authenticate to GitHub by providing an auth token in the `GH_TOKEN` environment variable, as above.
* **GitHub Copilot:** After Neovim starts, you can enable GitHub Copilot by running `:Copilot setup` from within Neovim. The completion key is mapped to `C-i` since `Tab` is already mapped.
* **Custom Vim Configurations:** Customizing the Vim configuration can be done in one of two ways:
  * Use a volume to mount an external configuration directory to the container, e.g. `--volume ~/.config/nvim:/root/.config/nvim`
  * Build a custom container image: clone/fork this repo, add customizations to the config, then build. (See "Advanced Use Case" below.)



## Advanced Use Case:

External Python dependencies can also be installed using a Dockerfile. This requires more setup, but is more flexible and simpler to run. This Dockerfile can also be added to your project repo, allowing developers to quickly set up a new dev environment.

```
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
```

Build the Dockerfile and run:

```
docker build -t neovim-image \
    --build-arg GIT_AUTHOR_EMAIL="you@example.com" \
    --build-arg GIT_AUTHOR_NAME="Your Name" \
    .

docker run -it --name neovim --volume .:/root/workspace \
    -e GH_TOKEN=$GH_TOKEN \
    neovim-image
```

Note that the `GIT_AUTHOR_*` settings are generally invariant, so they can be set at build time.



## Todo / Further Considerations:

* Integrate vim's clipboard with the host OS. Probably OSC 52 clipboard integration is the best solution.
* Vim users often try to optimize their config to minimize the startup time, and there is significantly greater overhead to start a container vs running natively. If this is a concern, one solution may be to use [nvr](https://github.com/mhinz/neovim-remote) to attach to the already-running Neovim instance. But, as the container's path differs from the local path, an additional wrapper around nvr would be required to translate paths.
* While all other editor setup is done automatically, you may notice GitHub Copilot users must still authenticate to GitHub manually before editing. The GitHub CLI  can authenticate using a token, so it would be ideal if Copilot could use a token for authentication, as well. (Also, because Neovim runs in the terminal, some environments won't have a browser available for the `:Copilot setup` authentication.) I have created a [feature request](https://github.com/orgs/community/discussions/127418) for this.