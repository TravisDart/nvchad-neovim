import time
from textwrap import dedent
import pytest
from .utils import wait_for_text


class TestBasicAutocomplete:
    """
    Move this to the parent directory to include in pytest.
    We test a more advanced autocomplete in other tests, so we don't need this.
    """

    @pytest.fixture(scope="class")
    def vim(self, tmux, local_container_name):
        tmux.send_keys(
            dedent(
                f"""\
            docker run -w /root -it --rm {local_container_name} sh -uelic '
            python -m venv /root/workspace_venv
            . /root/workspace_venv/bin/activate
            cat <<EOF > example.py
            import time
            
            time
            EOF
            nvim example.py
            '
        """
            )
        )

        try:
            # Wait for Vim to start
            assert wait_for_text(tmux, "NORMAL", verbose=True)
            yield tmux
        finally:
            # Send esc a few times to clear the autocomplete window.
            tmux.send_keys(chr(27) * 3, enter=False)
            tmux.send_keys(":qa!")

    def test_autocomplete(self, vim, tmux_verbose):
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
