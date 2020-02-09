#!/bin/bash
#
#  xsysroot-entrypoint.sh
#
#  Initial preparation of the xsysroot Docker container.
#

# Enable on-the-fly ARM emulation when needed
if [[ ! `uname -m` == *"arm"* ]]; then
    echo "Enabling QEmu on-the-fly ARM emulation"
    sudo update-binfmts --enable qemu-arm
fi

# Pass through to Docker command
/bin/bash -c "$*"
