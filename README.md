##Xsysroot

A tool that allows to work with multiple ARM emulated images on your Intel development system.

###Requirements

A Debian OS on a i686 system with the following packages installed:

 * qemu-user-static, qemu-utils, binfmt-support

An account with sudo password-less access.

The `nbd max_part=xx` kernel module loaded on the system (`/etc/modules`).
Tune number `xx` should be in sync with the number of images you need to mount concurrently.

Xsysroot works well on both 32 and 64 bit host systems. It should also play well on non Intel systems.

###Features

xsysroot starts by taking an ARM OS image and gives you a mounted environment
where you can chroot into, emualating ARM on the fly. The original image can be
provided in raw (img), gz, xz or zip formats.

Once you start working on the mounted image, all disk changes will go into a qcow image,
this enables to recreate the image at any point from scratch very quickly (-r option).
And because qcow images will grow dynamically, they are start very small in size
and are easy to share over the network, recreating the same sysroot environment on other systems.

The `tmp` mountpoint will be mapped on the host system, and will be accessible from
the sysroot fmor `/tmp`. This allows to access big space demanding data transparently.

The `xsysroot.conf` file is a collection of image profiles, which enables xsysroot
to mount several independent images at the same time. You can quickly jump between them
with the `-p` option.

For developers who want to build Debian packages, the `-k` option will give you a skeleton
directory to start with, the `-d` to install all `Build-Depends` in the sysroot, and finally
`-b` to go through a `debuild` process to cross build a package.

###Usage

The Xsysroot tool is one small python module. It provides a sample configuration file embedded
in the code, but you can also provide a system wide configuration file at `/etc/xsysroot.conf`,
or on your home directory at `~/xsyroot.conf`.

Copy xsysroot somewhere your path, and download the pipaOS image
on your home directory:

```
$ curl http://pipaos.mitako.eu/download/pipaos-3.5-wheezy-xgui.img.gz -o ~/pipaos-3.5-wheezy-xgui.img.gz
```

At this point you can quickly prepare a pipaOS sysroot by calling `xsysroot -r`,
which will uncompress and mount the image.

If you frequently play with multiple sysroots, I recommend you unzip the images upfront,
this will greatly speed up recreating them from scratch with.

```
Usage: xsysroot [options]

Options:
  -h, --help            show this help message and exit
  -v, --verbose         print more progress information
  -t, --tools           performs a basic test to see if system tools are ready
  -p PROFILE, --profile=PROFILE
                        switch to a different sysroot profile
  -l, --list            list all available sysroot profiles
  -s, --status          display settings and mount status
  -q VAR, --query=VAR   query a profile variable name
  -n, --running         display any processes currently running on the sysroot
  -i, --is-mounted      returns wether sysroot is mounted
  -r, --renew           rebuilds sysroot from scratch - QCOW DATA WILL BE LOST
  -e, --expand          expands sysroot partition to fit image size,
                        preserving data (must be ext2/ext3/ext4)
  -m, --mount           mount the current qcow image
  -u, --umount          unmount the current qcow image
  -c, --chroot          jumps you to an interactive ARM shell on the current
                        sysroot
  -x CMD, --execute=CMD
                        executes a command in the sysroot
  -o IMAGE_FILE, --screenshot=IMAGE_FILE
                        take a screenshot of the virtual display (extension
                        determines format)
  -d, --depends         installs Debian "Build-Depends" on the sysroot
  -b, --build           performs a Debian "debuild" on the host (cross build a
                        package)
  -k DIRECTORY, --skeleton=DIRECTORY
                        gives you a Debian package control directory skeleton
  -g GEOMETRY, --geometry=GEOMETRY
                        create and partition new image using geometry in MB
                        (e.g. "myimage.img fat32:40 ext3:200"
```

###Python

Because xsysroot is just one small python script, you can integrate it from your Python based automation processes.

```
$ sudo ln -s $(which xsysroot) $(python -c "import sys; print sys.path[1]")/xsysroot.py
$ python
Python 2.7.3 (default, Mar 14 2014, 11:57:14)
[GCC 4.7.2] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import xsysroot
>>> x=xsysroot.XSysroot()
>>> x.is_mounted()
True
>>> x.execute('uname -a')
sysroot executing: uname -a
Linux localhost 3.2.0-4-686-pae #1 SMP Debian 3.2.60-1+deb7u3 armv7l GNU/Linux
>>> x.chroot()
Starting ARM sysroot shell into: /tmp/pipaos
root@localhost:/# 
```

Enjoy!
