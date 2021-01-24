#!/usr/bin/env bash

# exit as soon as something fails
set -o errexit
set -o pipefail

if [[ ! -f /usr/bin/python3 ]]; then
    echo "Python 3 is required, but not found"
    exit 1
fi

PIP="python3 -m pip"

$PIP install --upgrade pip
$PIP install -r /opt/docker/python-requirements.txt
