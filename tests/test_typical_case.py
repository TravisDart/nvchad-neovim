import os

import pytest

from .utils import wait_for_text


class TestTypicalUseCase:
    @pytest.fixture(scope="class")
    def vim(self, tmux, request, github_token, git_username, git_email_address):
        # image_name = "travisdart/nvchad-neovim"
        image_name = "neovim-image"
        test_directory = os.path.dirname(request.path)
        asset_directory = os.path.join(test_directory, "typical_assets")

        tmux.send_keys(
            f"bash {asset_directory}/typical.sh {image_name} {github_token} {git_email_address} {git_username}"
        )

        # Wait for Vim to start
        assert wait_for_text(tmux, "NORMAL", verbose=True)

        yield tmux

        tmux.send_keys(":qa!")
        tmux.send_keys("docker stop neovim")
        tmux.send_keys("docker rm neovim")
        

    def test_autocomplete(self, vim):
        # Open the example file
        vim.send_keys(":e example.py")

        # Trigger autocomplete
        vim.send_keys("jj", enter=False)  # Down to line 3
        vim.send_keys("A", enter=False)  # Append at the end of the line
        vim.send_keys(".matrix_t", enter=False)

        # Autocomplete should suggest "matrix_transpose" for "matrix_t"
        assert wait_for_text(vim, "matrix_transpose", verbose=True, wiggle_char="t")

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
