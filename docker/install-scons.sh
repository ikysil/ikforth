#!/usr/bin/env bash

# exit as soon as something fails
set -o errexit
set -o pipefail

if [[ ! -f /usr/bin/python3 ]]; then
    echo "Python 3 is required, but not found"
    exit 1
fi

python3 -m venv /opt/scons
PIP="/opt/scons/bin/pip"

$PIP install --upgrade pip
$PIP install -r /opt/docker/python-requirements.txt

ln -s /opt/scons/bin/scons /usr/bin/scons

if [[ ! -x "$(command -v scons)" ]]; then
    echo SCons installation failed
    exit 1
fi
