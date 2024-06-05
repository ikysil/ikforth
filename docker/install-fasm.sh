#!/usr/bin/env bash

# exit as soon as something fails
set -o errexit
set -o pipefail

fasm_version=1.73.32
workdir=`mktemp -d fasm.XXXXXXXXXX`

chmod ugo+rwx "${workdir}"
cd "${workdir}"

wget http://flatassembler.net/fasm-${fasm_version}.tgz
tar -x --no-same-owner --no-same-permissions -f fasm-${fasm_version}.tgz
mv $PWD/fasm /opt/fasm-${fasm_version}
ln -s /opt/fasm-${fasm_version}/fasm /usr/local/bin/fasm

cd /opt/fasm-${fasm_version}/tools/libc

fasm listing.asm
gcc -m32 -o ../../listing listing.o
chmod +x ../../listing
ln -s $PWD/../../listing /usr/local/bin/listing

rm -rvf "${workdir}"
