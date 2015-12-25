#!/bin/sh
export PATH=/home/cdarkz/work_space/android/aosp_lollipop/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.8/bin:$PATH
KERNEL_PATH=/media/cdarkz/EXT_HD/android/kernel-lollipop/tegra_kernel-lollipop
TARGET_NAME=flounder
ARCH_NAME=arm64
CROSS_PREFIX=aarch64-linux-android-

make -j2 -C $KERNEL_PATH ARCH=$ARCH_NAME ${TARGET_NAME}_defconfig
make -j2 -C $KERNEL_PATH ARCH=$ARCH_NAME CROSS_COMPILE=$CROSS_PREFIX
