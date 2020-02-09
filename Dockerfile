#
#  Dockerfile for skarbat/xsysroot
#
#  A tool to create and manipulate Linux images for Embedded computer boards.
#
#  The MIT License (MIT)
#  Copyright (c) 2015-2020 Albert Casals
#

from debian:buster-slim

RUN apt-get update && apt-get -y install curl python sudo lsof parted dosfstools \
    qemu-user-static qemu-utils binfmt-support parted zerofree debootstrap git-core

COPY xsysroot /usr/local/bin
RUN chmod +x /usr/local/bin/xsysroot
RUN /usr/local/bin/xsysroot -U

RUN mkdir /var/cache/xsysroot
COPY xsysroot.conf /etc

# Prepare ARM emulation
COPY scripts/xsysroot-entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/xsysroot-entrypoint.sh"]
