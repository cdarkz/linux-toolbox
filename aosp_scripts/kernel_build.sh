#!/bin/sh
export PATH=/home/cdarkz/work_space/android/aosp_lollipop/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.8/bin:$PATH
make -j2 ARCH=arm64 flounder_defconfig
make -j2 ARCH=arm64 CROSS_COMPILE=aarch64-linux-android-
#make ARCH=arm64 menuconfig
