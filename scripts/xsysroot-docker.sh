#!/bin/bash
#
#  Script to open a Docker container with xsysroot ready to run.
#

set -e

osimages="$HOME/osimages"
systmp="$HOME/systmp"

mkdir -p $osimages $systmp
chmod 777 $osimages $systmp

docker run -it --privileged -v=/dev:/dev -v /proc:/proc \
       -v $osimages:/var/cache/xsysroot \
       -v $systmp:/tmp skarbat/xsysroot bash
