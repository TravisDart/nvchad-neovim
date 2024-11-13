#!/bin/bash
source "$(dirname "$0")/00_env.sh"

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Run the tests -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
ALL_TESTS_PASS=TRUE
for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  echo
  echo "Testing Python $PYTHON_VERSION image"

  docker run -it --rm --env CONTAINER_GH_TOKEN=$CONTAINER_GH_TOKEN  \
    -v /var/run/docker.sock:/var/run/docker.sock $PYTEST_CONTAINER_NAME \
    pytest \
    --local-container-name "${TEST_CONTAINER_PREFIX}${PYTHON_VERSION}" \
    --advanced-example-container-name "${ADVANCED_TEST_CONTAINER_PREFIX}${PYTHON_VERSION}" \
    --git-author-email $GIT_AUTHOR_EMAIL \
    --git-author-name $GIT_AUTHOR_NAME \
    --github-token $GH_TOKEN \
    --workspace-volume-name $WORKSPACE_VOLUME_NAME

  if [ $? -ne 0 ]; then
    ALL_TESTS_PASS=FALSE
  fi
done

if [[ "$ALL_TESTS_PASS" == "TRUE" ]]; then
  echo "All tests pass."
else
  echo "Some tests failed."
  exit 1
fi
