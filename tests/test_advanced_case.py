import os
import time
import uuid
from textwrap import dedent

import pytest

from .utils import wait_for_text


class TestAdvancedUseCase:
    @pytest.fixture(scope="class")
    def image_name(self, request):
        return f"neovim-overlay-image-{uuid.uuid4()}"

    @pytest.fixture(scope="class")
    def container_name(self, request):
        return f"neovim-{uuid.uuid4()}"

    @pytest.fixture(scope="class")
    def asset_directory(self, request):
        return os.path.join(os.path.dirname(request.path), "advanced_assets")

    @pytest.fixture(scope="class", autouse=True)
    def docker_image(
        self,
        request,
        asset_directory,
        image_name,
        container_name,
        git_username,
        git_email_address,
    ):
        os.system(
            dedent(
                f"""\
                    docker build --no-cache --progress=plain -t {image_name} \
                    --build-arg GIT_AUTHOR_EMAIL="{git_email_address}" \
                    --build-arg GIT_AUTHOR_NAME="{git_username}" \
                    {asset_directory}
                """
            )
        )

    @pytest.fixture(scope="class")
    def vim(
        self,
        tmux,
        tmux_verbose,
        asset_directory,
        image_name,
        container_name,
        github_token,
    ):
        tmux.send_keys(
            dedent(
                f"""\
                    docker run -w /root/workspace -it --name {container_name} --volume {asset_directory}:/root/workspace \
                    --env GH_TOKEN="{github_token}" \
                    {image_name}
                """
            )
        )

        # Wait for Vim to start
        assert wait_for_text(tmux, "NORMAL", verbose=tmux_verbose)

        yield tmux

        tmux.send_keys(":qa!")

    @pytest.fixture(scope="class")
    def clean_up(self, container_name, image_name):
        yield
        os.system(
            f"docker stop {container_name} && docker rm {container_name} && docker rmi {image_name}"
        )

    def test_autocomplete(self, vim, tmux_verbose):
        # Open the example file
        vim.send_keys(":e example.py")

        # Wait for the editor to load everything. There's no visual indication when this is complete, so just wait.
        # If we enter text before this, autocomplete won't work.
        time.sleep(5)

        # Trigger autocomplete
        vim.send_keys("jj", enter=False)  # Down to line 3
        vim.send_keys("A", enter=False)  # Append at the end of the line
        vim.send_keys(".matrix_t", enter=False)

        try:
            # Autocomplete should suggest "matrix_transpose" for "matrix_t"
            assert wait_for_text(vim, "matrix_transpose", verbose=tmux_verbose)
        finally:
            # Send esc a few times to clear the autocomplete window.
            vim.send_keys(chr(27) * 3, enter=False)

    def test_github(self, vim, tmux_verbose):
        vim.send_keys(":!gh auth status")
        assert wait_for_text(
            vim, "Logged in to github.com account", verbose=tmux_verbose, timeout=5
        )
        vim.enter()

    def test_git_email(self, vim, tmux_verbose, git_email_address):
        vim.send_keys(":!git config --global user.email")
        assert wait_for_text(vim, git_email_address, verbose=tmux_verbose, timeout=5)
        vim.enter()

    def test_git_name(self, vim, tmux_verbose, git_username):
        vim.send_keys(":!git config --global user.name")
        assert wait_for_text(vim, git_username, verbose=tmux_verbose, timeout=5)
        vim.enter()
