#!/bin/bash
set -e

#TODO: from changelog
version="0.2.0"

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

command="$1"
case "${command}" in
  build)
    distribution=$2
    if [ -z "$distribution" ]; then
      echo "must specify distribution to build"
      exit 1
    fi
    docker build -t ops-base:$distribution-$version --build-arg INSTALL_DOCKER=true . -f Dockerfile.$distribution
      ;;
  test)
    distribution=$2
    if [ -z "$distribution" ]; then
      echo "must specify distribution to build"
      exit 1
    fi
    docker run --privileged --rm --volume $PROJECT_DIR/test:/test ops-base:$distribution-$version './test/test.sh'
    ;;
  *)
      echo "Invalid command: '${command}'"
      exit 1
      ;;
esac
set +e
