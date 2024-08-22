from textwrap import dedent

from .utils import wait_for_text

def test_quickstart(vim):
    vim.send_keys(
        dedent(
            """\
        docker run -w /root -it --rm neovim-image sh -uelic '
        python -m venv /root/workspace_venv
        . /root/workspace_venv/bin/activate
        pip install numpy
        cat <<EOF > example.py
        import numpy
        
        numpy.linalg
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
    vim.send_keys(".matrix_t", enter=False)

    # Autocomplete should suggest "matrix_transpose" for "matrix_t"
    assert wait_for_text(vim, "matrix_transpose", verbose=True, wiggle_char="t")
