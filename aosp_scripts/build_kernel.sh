#!/bin/sh
export PATH=/mnt/SATA_HDD/android/aosp_marshmallow/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH
#export PATH=/mnt/SATA_HDD/android/aosp_marshmallow/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin:$PATH
KERNEL_PATH=/mnt/SATA_HDD/android/kernel-marshmallow/tegra_kernel-marshmallow
# TARGET_NAME/ARCH_NAME/CROSS_PREFIX: hammerhead/arm/arm-eabi- bullhead/arm64/aarch64-linux-android- flounder/arm64/aarch64-linux-android-
TARGET_NAME=flounder
ARCH_NAME=arm64
CROSS_PREFIX=aarch64-linux-android-

make -C $KERNEL_PATH ARCH=$ARCH_NAME ${TARGET_NAME}_defconfig
make -j4 -C $KERNEL_PATH ARCH=$ARCH_NAME CROSS_COMPILE=$CROSS_PREFIX

