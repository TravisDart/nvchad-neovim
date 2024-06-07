# Neovim (nvChad) Docker Container

This is a turnkey Python IDE using Neovim and Docker. With this container, setting up Vim is one Docker command, instead of requiring manual configuration and setup.

Other advantages of a containerized dev environment:

* Create many simultaneous development environments for different branches using this container with virtual machines or Kubernetes.
* Easily package a containerized reference IDE with your project. Even if developers choose another IDE, they can reference the Vim container for the setup requirements.
* Use this dev container to A/B test your dev environment. If something breaks in your primary IDE, this container allows you to quickly spin up a 2nd environment to see if the issue exists there, as well.



## Quickstart:

Run these lines to create a minimal Python project and start Neovim:

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

Edit the example file to test the Python autocomplete and formatting. Save the file to format it.) 

This is similar to the Docker-based preview in the [nvChad documentation](https://nvchad.com/docs/quickstart/install#install), but using the container from this project, you can try features like autocomplete and formatting without having to first invest time learning and customizing the config. 



## Typical Usage:

To use with an existing Python project, start the Neovim container in the root directory of your project. Your project will be mounted in the `/root/workspace` directory inside the container.

```
cd your_project

docker run -it --name neovim --volume .:/root/workspace \
    --env GIT_AUTHOR_EMAIL=you@example.com \
    --env GIT_AUTHOR_NAME="Your Name" \
    --env GH_TOKEN=$GH_TOKEN \
    travisdart/nvchad-neovim
```

Optional Features:

* **GitHub Integration:** The GitHub CLI (`gh` command) is included in the container. Authenticate to GitHub by providing an auth token to the `GH_TOKEN` environment variable, as above.
* **GitHub Copilot:** After Neovim starts, you can enable GitHub Copilot by running `:Copilot setup` from within Neovim. The completion key is mapped to `C-i` since `Tab` is already mapped.
* **Custom Vim Configurations:** To add customizations to the Vim configuration: clone/fork this repo, make your customizations to the config, and build (see the "Build" section below).



## External Python Dependencies

Neovim needs to reference your external dependencies for features such as autocomplete, so these dependencies must be added to the Neovim container. There are two ways to accomplish this:

* Method 1: Install the venv as an in-line script. This is the quickest method.

  ```
  docker run -w /root -it --rm travisdart/nvchad-neovim sh -uelic '
  python -m venv /root/workspace_venv
  source /root/workspace_venv/bin/activate
  pip install -r requirements.txt
  nvim
  '
  ```

* Method 2: Overlay the image. This method requires a little more setup, but is useful for including a reproducible IDE alongside your Python project.

  ```
  FROM travisdart/nvchad-neovim:latest
  
  RUN python -m venv /root/workspace_venv
  COPY requirements.txt /root/requirements.txt
  RUN pip install -r /root/requirements.txt
  
  ENTRYPOINT "source /root/workspace_venv/bin/activate && nvim"
  ```

  See the "Build" section below on how to build the container.

Note: In general, you can't create a virtual environment on the host, then activate it from the container. This would require creating the virtual environment using relative links, which are [not supposed on MacOS](https://github.com/pyenv/pyenv-virtualenv/pull/433). But, on some platforms this could theoretically be possible, and it would be pretty convenient in certain cases.



## Build:

Note: Since the `GIT_AUTHOR_*` settings are generally invariant, so they can be set at build time.

```
docker build -t neovim-image \
    --build-arg GIT_AUTHOR_NAME=you@example.com \
    --build-arg GIT_AUTHOR_EMAIL="Your Name" \
    .

docker run -it --name neovim --volume .:/root/workspace \
    -e GH_TOKEN=$GH_TOKEN \
    neovim-image
```



## Todo:

* Add integration to the host clipboard. (Currently copy/paste is scoped to the container and won't populate the host's clipboard.)