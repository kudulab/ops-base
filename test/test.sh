#!/bin/bash

set -e

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

service docker start
docker-wait

bats ${TEST_DIR}/bats
