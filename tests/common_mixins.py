import time

from tests.utils import wait_for_text


class CommonTests:
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
