#!/bin/bash
KERNEL_DIR=/media/cdarkz/EXT_HD/android/kernel-lollipop/tegra_kernel-lollipop
KERNEL_IMAGE=$KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
AOSP_DIR=/media/cdarkz/EXT_HD/android/aosp_lollipop
AOSP_LUNCH=aosp_flounder-userdebug

if [ -d $KERNEL_DIR ] && [ -d $AOSP_DIR ]; then
	echo "Building kernel..."
	set -x
	rm $KERNEL_IMAGE
	time ./build_kernel.sh
	if [ ! -f $KERNEL_IMAGE ]; then
		echo "Failed to build kernel image"
		exit 1
	fi

	echo "Building AOSP"
	cd $AOSP_DIR
	set +x
	source build/envsetup.sh
	lunch $AOSP_LUNCH
	echo make bootimage TARGET_PREBUILT_KERNEL=$KERNEL_IMAGE
	make bootimage TARGET_PREBUILT_KERNEL=$KERNEL_IMAGE
	#make updatepackage TARGET_PREBUILT_KERNEL=$KERNEL_IMAGE
else
	echo "$KERNEL_DIR or/and $AOSP_DIR don't exist!!"
fi
