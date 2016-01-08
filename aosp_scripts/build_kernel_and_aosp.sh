#!/bin/bash
KERNEL_DIR=/mnt/SATA_HDD/android/kernel-marshmallow/tegra_kernel-marshmallow
KERNEL_IMAGE=$KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
AOSP_DIR=/mnt/SATA_HDD/android/aosp_marshmallow
AOSP_LUNCH=aosp_flounder-userdebug

echo "KERNEL_DIR=${KERNEL_DIR}"
echo "KERNEL_IMAGE=${KERNEL_IMAGE}"
echo "AOSP_DIR=${AOSP_DIR}"
echo "AOSP_LUNCH=${AOSP_LUNCH}"

if [ -d $KERNEL_DIR ] && [ -d $AOSP_DIR ]; then
	echo "Building kernel..."
	rm $KERNEL_IMAGE
	time ./build_kernel.sh
	if [ ! -f $KERNEL_IMAGE ]; then
		echo "Failed to build kernel image"
		exit 1
	fi

	echo "Building AOSP"
	cd $AOSP_DIR
	source build/envsetup.sh
	lunch $AOSP_LUNCH
	echo make bootimage TARGET_PREBUILT_KERNEL=$KERNEL_IMAGE
	make bootimage TARGET_PREBUILT_KERNEL=$KERNEL_IMAGE
	#make updatepackage TARGET_PREBUILT_KERNEL=$KERNEL_IMAGE
else
	echo "$KERNEL_DIR or/and $AOSP_DIR don't exist!!"
fi
