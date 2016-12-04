#!/bin/bash -e

absname=`readlink -f "$0"`
absroot="$(dirname $absname)"
cfg="${absroot}/grte/grte.cfg"

[ -f $cfg ] || {
    echo "could not find $cfg"
    exit 1
}

. "$cfg"

if [[ -n $TAR_DIR ]]; then
  echo "changing to $TAR_DIR"
  test -d $TAR_DIR || mkdir -p $TAR_DIR
  cd $TAR_DIR
else
  echo "no sources"
fi

alias wget='wget -c'
wget https://ftp.gnu.org/gnu/glibc/glibc-${glibc_version}.tar.bz2
wget http://ftp.gnu.org/gnu/binutils/binutils-${binutils_version}.tar.bz2
wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/gcc-${gcc_version}.tar.bz2
wget https://ftp.gnu.org/gnu/gmp/gmp-${gmp_version}a.tar.bz2
wget https://ftp.gnu.org/gnu/mpfr/mpfr-${mpfr_version}.tar.bz2
wget https://ftp.gnu.org/gnu/mpc/mpc-${mpc_version}.tar.gz
wget http://zlib.net/zlib-${zlib_version}.tar.gz
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-${headers26}.tar.xz

GCC_BRANCH=branches/google/gcc-4_9
svn co svn://gcc.gnu.org/svn/gcc/${GCC_BRANCH}

CLANG_BRANCH=branches/google/stable
svn co http://llvm.org/svn/llvm-project/llvm/${CLANG_BRANCH} llvm
svn co http://llvm.org/svn/llvm-project/compiler-rt/${CLANG_BRANCH} llvm/projects/compiler-rt
svn co http://llvm.org/svn/llvm-project/cfe/${CLANG_BRANCH} llvm/tools/clang
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/${CLANG_BRANCH} llvm/tools/clang/tools/extra


