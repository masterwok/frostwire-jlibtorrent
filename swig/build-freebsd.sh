#!/usr/bin/env bash

# requirements:
# FreeBSD 11.1
# bash
# git
# openjdk8
# gradle
# wget

# result:
# you need to copy these libraries together
# from bin/release/freebsd/x86_64/
#
# libboost_system.so.1.67.0
# libtorrent.so.1.2.0
# libjlibtorrent.so

# boost: download and bootstrap
rm -rf boost_1_67_0
wget -nv --show-progress -O boost.zip https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.zip
unzip -qq boost.zip
cd boost_1_67_0
./bootstrap.sh
cd ..
export BOOST_ROOT=$PWD/boost_1_67_0

export OPENSSL_ROOT=/usr

# libtorrent: download and checkout revision
rm -rf libtorrent
git clone https://github.com/arvidn/libtorrent
cd libtorrent
git checkout e88a9a4ddafd07d202e381c4b9abc784eb476f20
cd ..
export LIBTORRENT_ROOT=$PWD/libtorrent

# compile jlibtorrent
rm -rf bin
export B2_PATH=${BOOST_ROOT}/tools/build/src/engine/bin.freebsdx86_64
${B2_PATH}/b2 --user-config=config/freebsd-x86_64-config.jam iconv=on variant=release toolset=clang-x86_64 target-os=freebsd location=bin/release/freebsd/x86_64
strip --strip-unneeded -x bin/release/freebsd/x86_64/libjlibtorrent.so
readelf -d bin/release/freebsd/x86_64/libjlibtorrent.so

# cd ../ and run gradle test
cp bin/release/freebsd/x86_64/libboost_system.so.1.67.0 ../
cp bin/release/freebsd/x86_64/libtorrent.so.1.2.0 ../
cp bin/release/freebsd/x86_64/libjlibtorrent.so ../
