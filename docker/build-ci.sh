#!/usr/bin/env bash

# keep going when something fails
set +e
set -o pipefail

docker_run() {
    echo "------------------------------------------------------"
    echo ">>> Executing $*"
    echo "------------------------------------------------------"
    docker run --rm -it -v $PWD:/opt/ikforth ikforth-build:latest -c "$*"
}

check_command() {
    docker_run "command -v $1 >/dev/null 2>&1"
}

skip() {
    echo "$*"
    exit 0
}

docker_run "echo -e '123\n ' | scons itc ansitest" || exit 1
docker_run "echo -e '123\n ' | scons dtc ansitest" || exit 1
docker_run "echo -e 'bye\n ' | scons fptest"       || exit 1

check_command "wine32" || skip ">>> WINE not installed, skipping..."
check_command "mingw32-g++" || skip ">>> Mingw32 not installed, skipping..."

docker_run "echo -e '123\n ' | scons itc term win32 ansitest" || exit 1
docker_run "echo -e '123\n ' | scons dtc term win32 ansitest" || exit 1
docker_run "echo -e 'bye\n ' | scons term win32 fptest"       || exit 1
