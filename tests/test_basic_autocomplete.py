from textwrap import dedent

from .utils import wait_for_text


def test_basic_autocomplete(docker_image, vim):

    vim.send_keys(
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
    assert wait_for_text(vim, "NORMAL", verbose=True)

    # Trigger autocomplete
    vim.send_keys("jj", enter=False)  # Down to line 3
    vim.send_keys("A", enter=False)  # Append at the end of the line
    vim.send_keys(".slee", enter=False)

    # Autocomplete should suggest "sleep" for "slee"
    assert wait_for_text(vim, "sleep", verbose=True, wiggle_char="e")
