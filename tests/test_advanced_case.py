import uuid
from textwrap import dedent

import pytest

from .common_mixins import CommonTests
from .utils import wait_for_text


class TestAdvancedUseCase(CommonTests):
    @pytest.fixture(scope="class")
    def vim(
        self,
        request,
        tmux,
        tmux_verbose,
        github_token,
        advanced_example_container_name,
        workspace_volume_name,
    ):
        container_name = f"neovim-{uuid.uuid4()}"
        image_name = "neovim-overlay-image:latest"
        # This uses the neovim-example-workspace volume, which was created during the build stage.
        tmux.send_keys(
            dedent(
                f"""\
                    docker run -w /root/workspace -it --name {container_name} \
                    --volume {workspace_volume_name}:/root/workspace \
                    --env GH_TOKEN="{github_token}" \
                    {advanced_example_container_name}
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
