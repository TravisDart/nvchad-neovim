import time
from textwrap import dedent

from .utils import wait_for_text


class TestBasicAutocomplete:
    def test_basic_autocomplete(self, tmux, tmux_verbose):

        tmux.send_keys(
            dedent(
                """\
            docker run -w /root -it --rm neovim-image sh -uelic '
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

        # Wait for Vim to start
        assert wait_for_text(tmux, "NORMAL", verbose=tmux_verbose)

        # Wait for the editor to load everything. There's no visual indication when this is complete, so just wait.
        # If we enter text before this, autocomplete won't work.
        time.sleep(5)

        # Trigger autocomplete
        tmux.send_keys("jj", enter=False)  # Down to line 3
        tmux.send_keys("A", enter=False)  # Append at the end of the line
        tmux.send_keys(".slee", enter=False)

        try:
            # Autocomplete should suggest "sleep" for "slee"
            assert wait_for_text(tmux, "sleep", verbose=tmux_verbose)
        finally:
            # Send esc a few times to clear the autocomplete window.
            tmux.send_keys(chr(27) * 3, enter=False)
            tmux.send_keys(":qa!")
