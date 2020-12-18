#!/usr/bin/env bash

# exit as soon as something fails
set -o errexit
set -o pipefail

docker_run() {
    echo "------------------------------------------------------"
    echo ">>> Executing $*"
    echo "------------------------------------------------------"
    docker run --rm -i --env BUILD_TAG -v $PWD:/opt/ikforth ikforth-build:latest -c "$*"
}

check_command() {
    docker_run "command -v $1 >/dev/null 2>&1"
}

skip() {
    echo "$*"
    exit 0
}

docker_run "yes bye | docker/hide-logs.sh scons linux itc all ansitest" || exit 1
docker_run "yes bye | docker/hide-logs.sh scons linux dtc all ansitest" || exit 1
docker_run "yes bye | docker/hide-logs.sh scons linux fptest"           || exit 1

check_command "wine32" || skip ">>> wine32 not installed, skipping..."
check_command "mingw32-g++" || skip ">>> mingw32-g++ not installed, skipping..."
check_command "mingw32-gcc" || skip ">>> mingw32-gcc not installed, skipping..."

docker_run "yes bye | docker/hide-logs.sh scons win32 itc term all ansitest" || exit 1
docker_run "yes bye | docker/hide-logs.sh scons win32 dtc term all ansitest" || exit 1
docker_run "yes bye | docker/hide-logs.sh scons win32 term fptest"           || exit 1

docker_run "scons dist" || exit 1
