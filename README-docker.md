## Xsysroot Docker

Running xsysroot through Docker makes life a lot simpler.
This document explains how run xsysroot through Docker.

### Installation Steps

The Docker image will run on X86 and ARM architectures.
From the host, you first need to load the Network Block Device kernel module:

```
$ sudo mobprobe nbd
```

Then simply run `scripts/xsysroot-docker.sh` bash. You should be inside a xsysroot environment.
Type xsysroot --help for details, or follow the online document: http://xsysroot.mitako.eu

### Example: Mounting a pipaOS image

Prepare the host directories:

```
$ mkdir -p $HOME/osimages $HOME/systmp
$ chown 777 $HOME/osimages $HOME/systmp
```

Download the latest pipaos image from the [official site](http://pipaos.mitako.eu/):

```
$ curl -L http://pipaos.mitako.eu/download/pipaos-6.0-buster.img.gz | gunzip -c > $HOME/osimages/pipaos-latest.img
```

Execute `scripts/xsysroot-docker.sh` to enter xsysroot, and then:

```
$ xsysroot --renew
$ xsysroot --chroot
```

You should now be inside the pipaOS image.

Albert Casals, February 2020
