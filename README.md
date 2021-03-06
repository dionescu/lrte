LRTE
====

Fork of https://code.google.com/p/google-search-appliance-mirror/downloads/detail?name=grte-1.2.2-src.tar.bz2&amp;can=2&amp;q=

Original source code downloaded from:

https://google-search-appliance-mirror.googlecode.com/files/grte-1.2.2-src.tar.bz2
https://google-search-appliance-mirror.googlecode.com/files/crosstoolv13-gcc-4.4.0-glibc-2.3.6-grte-1.0-36185.src.rpm
https://google-search-appliance-mirror.googlecode.com/files/grte-python2.4-2.4.6-7.src.tar.bz2

Original github repo: https://github.com/mzhaom/lrte

Install and Usage
=================

It's recommended to just install the precomiled packages from release
page. For example, to install lrtev2 with crosstool v2:

```
apt-get update
apt-get install -y apt-transport-https
echo 'deb https://github.com/dionescu/lrte/releases/download/lrtev2 ./' >> /etc/apt/sources.list
apt-get update
apt-get install -y --force-yes lrtev2-crosstoolv2-gcc-4.9 lrtev2-crosstoolv2-clang-4.0
```

__Important__: If you want to handle MSAN instrumented builds, you will
need to build an instrumented libstdc++ using the crosstool. To do
this, simply run the ```msan.sh``` script after you install LRTE
(note that you may need to modify the script if you installed LRTE
in a non-default location). The instrumented libstdc++ will be placed
under _path_to_crosstool_base_/gcc-4.9.2-lrtev2/x86/lib64/msan.

On the production machines, you should need to install ```lrtev2-runtime```
package, which contains the glibc and libstdc++ libraries. Then gcc and
clang under /usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/bin can be used to
produce binaries that only work with LRTE, which means these binaries
only depend on glibc and libstdc++ coming from LRTE runtime, so they
can be shipped without worrying about the system's glibc version.

Btw: the gcc and clang inside crosstool are linked against LRTE runtime
and they can pretty much run on any release of ubuntu or redhat.

For example:

```
# /usr/lrte/v2/bin/ldd /usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/bin/clang
        linux-vdso.so.1 (0x00007ffc388cf000)
        libdl.so.2 => /usr/lrte/v2/lib64/libdl.so.2 (0x00007f6e55453000)
        libpthread.so.0 => /usr/lrte/v2/lib64/libpthread.so.0 (0x00007f6e55236000)
        libz.so.1 => /usr/lrte/v2/lib64/libz.so.1 (0x00007f6e5501c000)
        libstdc++.so.6 => /usr/lrte/v2/lib64/libstdc++.so.6 (0x00007f6e54d12000)
        libm.so.6 => /usr/lrte/v2/lib64/libm.so.6 (0x00007f6e54a0a000)
        libgcc_s.so.1 => /usr/lrte/v2/lib64/libgcc_s.so.1 (0x00007f6e547f4000)
        libc.so.6 => /usr/lrte/v2/lib64/libc.so.6 (0x00007f6e54431000)
        /usr/lrte/v2/lib64/ld-linux-x86-64.so.2 (0x00007f6e55657000)
```

You can also refer to the [build
guide](https://github.com/dionescu/lrte/wiki) if you prefer
building everything from source code for further customization.
