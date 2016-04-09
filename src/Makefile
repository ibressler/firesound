# Makefile
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.
#
# build script for stdbuf using the Android NDK tools

ndkpath = ${HOME}/android/android-ndk-r11c
toolarch = aarch64-linux-android
toolchain = ${ndkpath}/toolchains/${toolarch}-*/prebuilt/*
platform = ${ndkpath}/platforms/android-21/arch-arm64

CC = ${toolchain}/bin/${toolarch}-gcc

all: stdbuf.so

stdbuf.so:
	${CC} --sysroot=${platform} -O2 -Wall -x c -s -fPIC -shared -o stdbuf.so stdbuf.c

clean:
	rm -f *.o *.i *.s *.so

