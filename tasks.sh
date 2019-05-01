#!/bin/bash
set -e

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SECRET_OPS_VERSION="0.6.2"
RELEASER_VERSION="2.0.0"

RELEASER_FILE="ops/releaser-${RELEASER_VERSION}"
SECRET_OPS_FILE="ops/secret-ops"
SECRET_OPS_TAR_FILE="ops/secret-ops-${SECRET_OPS_VERSION}.tar.gz"

mkdir -p ops
if [[ ! -f $SECRET_OPS_TAR_FILE ]];then
  wget --quiet -O $SECRET_OPS_TAR_FILE https://github.com/kudulab/secret-ops/releases/download/${SECRET_OPS_VERSION}/secret-ops.tar.gz
  tar -xf $SECRET_OPS_TAR_FILE -C ops
fi
source $SECRET_OPS_FILE

if [[ ! -f $RELEASER_FILE ]];then
  wget --quiet -O $RELEASER_FILE https://github.com/kudulab/releaser/releases/download/${RELEASER_VERSION}/releaser
fi
source $RELEASER_FILE

command="$1"
case "${command}" in
  set_version)
      releaser::bump_changelog_version "$2" "$3"
      ;;
  build)
    distribution=$2
    if [ -z "$distribution" ]; then
      echo "must specify distribution to build"
      exit 1
    fi
    docker build -t ops-base:$distribution --build-arg INSTALL_DOCKER=true --build-arg INSTALL_AIT_CA=true . -f Dockerfile.$distribution
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
    docker run --privileged -e VAULT_TOKEN=$VAULT_TOKEN -t --rm --volume $component_dir:/test ops-base:$distribution bash -c 'sudo service docker start && cd ./test/ && ./tasks test'
    ;;
  release)
    # conditional release
    git fetch origin
    current_commit_git_tags=$(git tag -l --points-at HEAD)
    if [[ "${current_commit_git_tags}" != "" ]];then
      releaser::log_info "Current commit is already tagged, skipping code release"
    else
      releaser::log_info "Current commit has no tags, starting code release..."
      releaser::verify_release_ready
      releaser::git_tag_from_changelog
    fi
    ;;
  generate_vault_token)
    vault_token=$(vault token create -orphan -ttl=48h -policy=gocd -field token -metadata gocd_renew=true)
    secured_token_gocd=$(secret_ops::encrypt_with_gocd_top "${vault_token}")
    echo "Generated token: ${vault_token} and encrypted by GoCD server"
    secret_ops::insert_vault_token_gocd_yaml "${secured_token_gocd}"
    ;;
  *)
      echo "Invalid command: '${command}'"
      exit 1
      ;;
esac
set +e
