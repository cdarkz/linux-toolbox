#!/bin/sh
# $1: device codename

# DEVICE_NAME:
#  Nexus 5X = bullhead
#  Nexus 6P = angler
#  Nexus 9 = flounder
#  Nexus 5 = hammerhead
#  Nexus 7 (2013) = flo
DEVICE_NAME=flounder
if [ -n $1 ]; then
	DEVICE_NAME=$1
fi

case $DEVICE_NAME in
    "bullhead")
	export PATH=/mnt/SATA_HDD/android/aosp_marshmallow/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH
	KERNEL_PATH=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow
	ARCH_NAME=arm64
	CROSS_PREFIX=aarch64-linux-android-
	GIT_BRANCH_NAME=android-msm-bullhead-3.10-marshmallow-dr
	;;
    "angler")
	export PATH=/mnt/SATA_HDD/android/aosp_marshmallow/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH
	KERNEL_PATH=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow
	ARCH_NAME=arm64
	CROSS_PREFIX=aarch64-linux-android-
	GIT_BRANCH_NAME=android-msm-angler-3.10-marshmallow-dr
	;;
    "flounder")
	export PATH=/mnt/SATA_HDD/android/aosp_marshmallow/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH
	KERNEL_PATH=/mnt/SATA_HDD/android/kernel-marshmallow/tegra_kernel-marshmallow
	ARCH_NAME=arm64
	CROSS_PREFIX=aarch64-linux-android-
	GIT_BRANCH_NAME=android-tegra-flounder-3.10-marshmallow
	;;
    "hammerhead")
	export PATH=/mnt/SATA_HDD/android/aosp_marshmallow/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin:$PATH
	KERNEL_PATH=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow_arm
	ARCH_NAME=arm
	CROSS_PREFIX=arm-eabi-
	GIT_BRANCH_NAME=android-msm-hammerhead-3.4-marshmallow
	;;
    "flo")
	export PATH=/mnt/SATA_HDD/android/aosp_marshmallow/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin:$PATH
	KERNEL_PATH=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow_arm
	ARCH_NAME=arm
	CROSS_PREFIX=arm-eabi-
	GIT_BRANCH_NAME=android-msm-flo-3.4-marshmallow
	;;
    *)
	echo "Error DEVICE_NAME!!"
	exit 1
	;;
esac


# main
git -C ${KERNEL_PATH} checkout ${GIT_BRANCH_NAME}
make -C ${KERNEL_PATH} ARCH=${ARCH_NAME} ${DEVICE_NAME}_defconfig
make -j4 -C ${KERNEL_PATH} ARCH=${ARCH_NAME} CROSS_COMPILE=${CROSS_PREFIX}

