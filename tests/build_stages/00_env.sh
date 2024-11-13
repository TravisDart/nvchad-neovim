# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= env setup -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# These variables are used both in the build stage and in tests.

# Run this from the project root directory.
cd "$(dirname "$0")"
cd ../..

# GH_TOKEN="..." Set this in your environment before running tests.
GIT_AUTHOR_EMAIL="28a63484-6564-4a05-8830-b1526fdee4e0@example.com"
GIT_AUTHOR_NAME="c79a0846-b2f3-4d6b-83c2-35314d24f8d4"

PYTHON_VERSIONS=(3.9 3.10 3.11 3.12)

DOCKER_PREFIX="neovim-6d4289a3-8b25-44fa-a0dc-7a6612fecfdf-"
BUILD_IMAGE_PREFIX="${DOCKER_PREFIX}image:python"
PUBLISHED_IMAGE_PREFIX="travisdart/nvchad-neovim:python"
PYTEST_CONTAINER_NAME="${DOCKER_PREFIX}pytest"
WORKSPACE_VOLUME_NAME="${DOCKER_PREFIX}workspace"
ADVANCED_TEST_CONTAINER_PREFIX="${DOCKER_PREFIX}advanced-test-container:python"
if [[ "$@" == "--published" ]]; then
  TEST_CONTAINER_PREFIX="travisdart/nvchad-neovim:python"
  echo "Using published containers."
else
  TEST_CONTAINER_PREFIX="${DOCKER_PREFIX}test-container:python"
  echo "Using local containers."
fi
