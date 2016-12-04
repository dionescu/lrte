# Built using instructions from https://code.google.com/p/memory-sanitizer/wiki/InstrumentingLibstdcxx.
# Note: This assumes you have lrtev2 in the standard location. You need to change this accordingly if a
# different lrte version/location is used.
CLANG=/usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/bin/clang
CLANGXX=/usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/bin/clang++
CLANG_HEADERS=$($CLANGXX -v -xc++ -c /dev/null |& grep -E 'lib/clang/[01-9.]+/include$' | head -1 | sed 's/ \+//')
GCC=/usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/bin/gcc
RUNTIME=/usr/lrte/v2/include
# We need gcc's unwind.h. Either use the one for system-wide gcc installation if its fresh enough, or build gcc from the source on the side.
GCC_HEADERS=$($GCC -v -xc++ -c /dev/null |& grep -E '/include$' | head -1 | sed 's/ \+//')
MSAN_CFLAGS="-fsanitize=memory -isystem $CLANG_HEADERS -isystem $GCC_HEADERS -isystem $RUNTIME  -g -O2 -fno-omit-frame-pointer"
MSAN_LDFLAGS="-fsanitize=memory"
mkdir build_msan && cd build_msan
CC="$CLANG" CXX="$CLANGXX" CFLAGS="$MSAN_CFLAGS" CXXFLAGS="$MSAN_CFLAGS" LDFLAGS="$MSAN_LDFLAGS" \
../sources/gcc-4_9/libstdc++-v3/configure --enable-multilib=no
sed -i '/\/\* #undef HAVE_CC_TLS \*\//c\#define HAVE_CC_TLS 1' config.h
sed -i '/\/\* #undef HAVE_TLS \*\//c\#define HAVE_TLS 1' config.h
make -j10
cd src/.libs
MSAN_DIR=/usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/lib64/msan
sudo mkdir -p ${MSAN_DIR}
sudo cp --no-dereference libstdc++.a libstdc++.so* ${MSAN_DIR}
cd ..
rm -rf build_msan



