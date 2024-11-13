import uuid
from textwrap import dedent

import pytest

from .common_mixins import CommonTests
from .utils import wait_for_text


class TestTypicalUseCase(CommonTests):
    @pytest.fixture(scope="class")
    def vim(
        self,
        tmux,
        request,
        github_token,
        git_username,
        git_email_address,
        local_container_name,
        workspace_volume_name,
    ):
        container_name = f"neovim-{uuid.uuid4()}"

        # This uses the workspace volume that was created during the build stage.
        tmux.send_keys(
            dedent(
                f"""\
                    docker run -w /root/workspace -it --name {container_name} \
                    --volume {workspace_volume_name}:/root/workspace \
                    --env GIT_AUTHOR_EMAIL="{git_email_address}" \
                    --env GIT_AUTHOR_NAME="{git_username}" \
                    --env GH_TOKEN="{github_token}" \
                    {local_container_name} sh -uelic '
                    git config --global user.email "$GIT_AUTHOR_EMAIL"
                    git config --global user.name "$GIT_AUTHOR_NAME"
                    python -m venv /root/workspace_venv
                    source /root/workspace_venv/bin/activate
                    pip install -r requirements.txt
                    nvim
                    '
                """
            )
        )

        try:
            # Wait for Vim to start
            assert wait_for_text(tmux, "NORMAL", verbose=True)
            yield tmux
        finally:
            tmux.send_keys(":qa!")
            tmux.send_keys(
                f"docker stop {container_name} && docker rm {container_name}"
            )
