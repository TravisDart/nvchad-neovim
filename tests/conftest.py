import uuid

import libtmux
import pytest


def pytest_addoption(parser):
    parser.addoption(
        "--tmux-verbose",
        action="store_true",
        default=False,
        help="Display tmux output",
    )
    parser.addoption("--github-token")
    parser.addoption("--git-author-name")
    parser.addoption("--git-author-email")
    parser.addoption("--workspace-volume-name")
    parser.addoption("--local-container-name")
    parser.addoption("--advanced-example-container-name")


@pytest.fixture(scope="session")
def github_token(pytestconfig):
    return pytestconfig.getoption("--github-token")


@pytest.fixture(scope="session")
def git_username(pytestconfig):
    return pytestconfig.getoption("--git-author-name")


@pytest.fixture(scope="session")
def git_email_address(pytestconfig):
    return pytestconfig.getoption("--git-author-email")


@pytest.fixture(scope="session")
def workspace_volume_name(pytestconfig):
    return pytestconfig.getoption("--workspace-volume-name")


@pytest.fixture(scope="session")
def local_container_name(pytestconfig):
    return pytestconfig.getoption("--local-container-name")


@pytest.fixture(scope="session")
def advanced_example_container_name(pytestconfig):
    return pytestconfig.getoption("--advanced-example-container-name")


@pytest.fixture(scope="session")
def tmux_verbose(pytestconfig):
    return pytestconfig.getoption("--tmux-verbose")


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
