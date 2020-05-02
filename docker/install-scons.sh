#!/usr/bin/env bash

# exit as soon as something fails
set -o errexit
set -o pipefail

if [[ ! -f /usr/bin/python ]]; then
    ln -s /usr/bin/python3 /usr/bin/python
fi

PIP="python -m pip"

$PIP install --upgrade pip
$PIP install --prefix=/opt/scons -r /opt/docker/python-requirements.txt

ln -s /opt/scons/bin/scons /usr/local/bin/scons
