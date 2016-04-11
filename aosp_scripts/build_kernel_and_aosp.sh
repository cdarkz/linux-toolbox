#!/bin/bash
# $1: device codename

# DEVICE_NAME:
#  Nexus 5X = bullhead
#  Nexus 6P = angler
#  Nexus 9 = flounder
#  Nexus 5 = hammerhead
#  Nexus 7 (2013) = flo
DEVICE_NAME=flounder
if [[ $1 ]]; then
	DEVICE_NAME=$1
fi

ALL=0
if [[ $2 == "all" ]]; then
	ALL=1	
fi

case ${DEVICE_NAME} in
    "bullhead")
	KERNEL_DIR=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow
	KERNEL_IMAGE=${KERNEL_DIR}/arch/arm64/boot/Image.gz-dtb
	;;
    "angler")
	KERNEL_DIR=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow
	KERNEL_IMAGE=${KERNEL_DIR}/arch/arm64/boot/Image.gz-dtb
	;;
    "flounder")
	KERNEL_DIR=/mnt/SATA_HDD/android/kernel-marshmallow/tegra_kernel-marshmallow
	KERNEL_IMAGE=${KERNEL_DIR}/arch/arm64/boot/Image.gz-dtb
	;;
    "hammerhead")
	KERNEL_DIR=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow_arm
	KERNEL_IMAGE=${KERNEL_DIR}/arch/arm/boot/zImage-dtb
	;;
    "flo")
	KERNEL_DIR=/mnt/SATA_HDD/android/kernel-marshmallow/msm_kernel-marshmallow_arm
	KERNEL_IMAGE=${KERNEL_DIR}/arch/arm/boot/zImage
	;;
    *)
	echo "Error DEVICE_NAME!!"
	exit 1
	;;
esac

AOSP_LUNCH=aosp_${DEVICE_NAME}-userdebug
AOSP_DIR=/mnt/SATA_HDD/android/aosp_marshmallow

# main
echo "KERNEL_DIR=${KERNEL_DIR}"
echo "KERNEL_IMAGE=${KERNEL_IMAGE}"
echo "AOSP_DIR=${AOSP_DIR}"
echo "AOSP_LUNCH=${AOSP_LUNCH}"

if [ -d ${KERNEL_DIR} ] && [ -d ${AOSP_DIR} ]; then
	echo "Building kernel..."
	rm ${KERNEL_IMAGE}
	time ./build_kernel.sh ${DEVICE_NAME}
	if [ ! -f ${KERNEL_IMAGE} ]; then
		echo "Failed to build kernel image"
		exit 1
	fi

	echo "Building AOSP"
	cd ${AOSP_DIR}
	source build/envsetup.sh
	lunch ${AOSP_LUNCH}

	if [ ${ALL} == 1 ]; then
	  echo make updatepackage TARGET_PREBUILT_KERNEL=${KERNEL_IMAGE}
	  make updatepackage TARGET_PREBUILT_KERNEL=${KERNEL_IMAGE}
	else
	  echo make bootimage TARGET_PREBUILT_KERNEL=${KERNEL_IMAGE}
	  make bootimage TARGET_PREBUILT_KERNEL=${KERNEL_IMAGE}
	fi
else
	echo "${KERNEL_DIR} or/and ${AOSP_DIR} don't exist!!"
fi
