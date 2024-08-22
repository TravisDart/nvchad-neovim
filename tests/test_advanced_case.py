import os
import uuid
from textwrap import dedent

import pytest

from .utils import wait_for_text


class TestAdvancedUseCase:
    @pytest.fixture(scope="class", autouse=True)
    def docker_image(self, request):
        image_name = f"neovim-overlay-image-{uuid.uuid4()}"
        test_directory = os.path.dirname(request.path)
        asset_directory = os.path.join(test_directory, "advanced_assets")

        os.system(
            dedent(
                f"""\
            docker build --progress=plain -t {image_name} \
            --build-arg GIT_AUTHOR_EMAIL="you@example.com" \
            --build-arg GIT_AUTHOR_NAME="Your Name" \
            {asset_directory}
        """
            )
        )

        yield

        os.system(f"docker rmi {image_name}")

    @pytest.fixture(scope="function")
    def vim(self, tmux):
        tmux.send_keys(
            dedent(
                f"""\
                    docker run -it --rm --volume .:/root/workspace \
                        -e GH_TOKEN=$GH_TOKEN \
                        neovim-image
                """
            )
        )

        # Wait for Vim to start
        assert wait_for_text(tmux, "NORMAL", verbose=True)

        yield tmux

        tmux.send_keys(":qa!")

    def test_autocomplete(self, vim):
        # Open the example file
        vim.send_keys(":e typical_assets/example.py")

        # Trigger autocomplete
        vim.send_keys("jj", enter=False)  # Down to line 3
        vim.send_keys("A", enter=False)  # Append at the end of the line
        vim.send_keys(".matrix_t", enter=False)

        # Autocomplete should suggest "matrix_transpose" for "matrix_t"
        # assert wait_for_text(vim, "matrix_transpose", verbose=True, wiggle_char='t')
        assert wait_for_text(vim, "matrix_transpose", verbose=True)

    def test_github(self, vim):
        vim.send_keys(":!gh auth status")
        assert wait_for_text(vim, "Logged in to github.com account", verbose=True, timeout=5)

    def test_git_email(self, vim, git_email_address):
        vim.send_keys(":!git config --global user.email")
        assert wait_for_text(vim, git_email_address, verbose=True, timeout=5)
        vim.enter()

    def test_git_name(self, vim, git_username):
        vim.send_keys(":!git config --global user.name")
        assert wait_for_text(vim, git_username, verbose=True, timeout=5)
        vim.enter()
