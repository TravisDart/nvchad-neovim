import os
import uuid

import libtmux
import pytest

remote_container_name = "travisdart/nvchad-neovim"


def pytest_addoption(parser):
    parser.addoption(
        "--local",
        action="store_true",
        dest="record",
        default=False,
        help=f"Use the local neovim container instead of {remote_container_name}",
    )

    parser.addoption(
        "--local-container-name",
        help='Name of the local container.',
    )

    parser.addoption(
        "--advanced-example-container-name",
        help='Name of the local container.',
    )

    parser.addoption(
        "--tmux-verbose",
        action="store_true",
        default=False,
        help="Display tmux output",
    )


def pytest_configure(config):
    if config.getoption("--local"):
        config.option.container_name = config.getoption("--local-container-name")
    else:
        config.option.container_name = remote_container_name


@pytest.fixture(scope="class")
def tmux():
    slug = uuid.uuid4()
    session = libtmux.Server(colors=256).new_session(session_name=f"vim_test-{slug}")
    try:
        window = session.new_window(window_name=f"vim_window-{slug}")
        window.resize(height=40, width=120)
        pane = window.active_pane

        # Pass the pane as an argument to the wrapped function
        yield pane
    finally:
        session.kill()


@pytest.fixture(scope="session")
def github_token():
    return os.getenv("CONTAINER_GH_TOKEN")


@pytest.fixture(scope="session")
def git_username():
    return str(uuid.uuid4())


@pytest.fixture(scope="session")
def git_email_address():
    return f"{uuid.uuid4()}@example.com"


@pytest.fixture(scope="session")
def tmux_verbose(pytestconfig):
    """For brevity"""
    return pytestconfig.getoption("--tmux-verbose")
