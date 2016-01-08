#!/bin/bash
AOSP_DIR=/mnt/SATA_HDD/android/aosp_marshmallow
AOSP_TARGET=flounder
AOSP_BOOT_FILE=$AOSP_DIR/out/target/product/$AOSP_TARGET/boot.img

if [ -f $1 ]; then
	AOSP_BOOT_FILE=$1
fi

check_state() {                                                                           
	adb_state=`adb get-state`
	fb_state=`fastboot devices`
	if [ "$adb_state" == "device" ]; then
		return 1;
	elif [ "$fb_state" != "" ]; then
		return 2;
	fi

	return 0
}

if [ -d $AOSP_DIR ]; then
	echo "******************************"
	echo "* 1. Check USB debug mode *"
	check_state
	if [ $? == 1 ]; then
		echo "The device is on USB debug mode"
	else
		echo "The device is NOT on USB debug mode"
		echo "Please enable USB debug mode"
		exit 1
	fi

	echo "******************************"
	echo "* 2. Load last boot.img *"
	adb reboot bootloader
	echo fastboot flash boot $AOSP_DIR/out/target/product/$AOSP_TARGET/boot.img
	fastboot flash boot $AOSP_BOOT_FILE
	fastboot reboot
	adb wait-for-device
	echo "******************************"
	echo "* 3. Change to root mode *"
	adb root
	adb wait-for-device
	echo "******************************"
	echo "* 4. Print out kernel message *"
	adb shell cat /proc/kmsg
else
	echo "$AOSP_DIR don't exist!!"
fi
