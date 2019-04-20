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
    docker build -t ops-base:$distribution --build-arg INSTALL_DOCKER=true . -f Dockerfile.$distribution
      ;;
  build_gui)
    distribution=$2
    if [ -z "$distribution" ]; then
      echo "must specify distribution to build"
      exit 1
    fi
    docker build -t ops-base:$distribution-gui . -f Dockerfile.$distribution-gui
      ;;
  test)
    distribution=$2
    if [ -z "$distribution" ]; then
      echo "must specify distribution to test"
      exit 1
    fi
    docker run --privileged --rm --volume $PROJECT_DIR/test:/test ops-base:$distribution './test/test.sh'
    ;;
  itest)
    distribution=$2
    component=$3
    if [ -z "$distribution" ]; then
      echo "must specify distribution to test"
      exit 1
    fi
    if [ -z "$component" ]; then
      echo "must specify component to test with"
      exit 1
    fi
    component_dir="$(readlink -f $PROJECT_DIR/../$component)"
    echo "Testing with $component at $component_dir"
    docker run --privileged --rm --volume $component_dir:/test ops-base:$distribution bash -c 'cd ./test/ && ./tasks test'
    ;;
  *)
      echo "Invalid command: '${command}'"
      exit 1
      ;;
esac
set +e
