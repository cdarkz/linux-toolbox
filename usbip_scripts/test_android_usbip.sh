#!/bin/bash
AOSP_DIR=/media/cdarkz/EXT_HD/android/aosp_lollipop
AOSP_TARGET=flounder
AOSP_BOOT_FILE=/home/cdarkz/work_space/android/aosp_output/boot_triple_3run_usbip.img
TWRP_FILE=/home/cdarkz/work_space/android/root_recovery/twrp-2.8.7.0-${AOSP_TARGET}.img
USBIP_DIR=/home/cdarkz/work_space/usbip/output/triple_for_nexus9

if [[ -n $1 ]]; then
	AOSP_BOOT_FILE=$1
fi

if [[ -n $2 ]]; then
	USBIP_DIR=$2
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

if [ -f $AOSP_BOOT_FILE ]; then
	echo "******************************"
	echo "* 1. Check USB debug mode"
	check_state
	if [ $? == 1 ]; then
		echo "The device is on USB debug mode"
	else
		echo "The device is NOT on USB debug mode"
		echo "Please enable USB debug mode"
		exit 1
	fi

	echo "******************************"
	echo "* 2. Boot to TWRP (${TWRP_FILE})"
	adb reboot bootloader
	fastboot boot $TWRP_FILE

	echo "******************************"
	echo "* 3. Install USBIP cli *"
	sleep 15
	adb shell mount /system
	adb push $USBIP_DIR/usbip /system/xbin/usbip
	adb push $USBIP_DIR/libusbip.so.0.0.1 /system/usr/lib/libusbip.so.0.0.1
	adb push $USBIP_DIR/libusbip.so.0.0.1 /system/usr/lib/libusbip.so.0
	adb push $USBIP_DIR/libusbip.so.0.0.1 /system/usr/lib/libusbip.so
	adb shell chown :shell /system/usr/lib/libusbip*
	adb shell chmod 0755 /system/usr/lib/libusbip*
	adb reboot bootloader

	echo "******************************"
	echo "* 4. Load ${AOSP_BOOT_FILE}"
	fastboot flash boot $AOSP_BOOT_FILE
	fastboot reboot
	adb wait-for-device

	echo "******************************"
	echo "* 5. Change to root mode"
	adb root
	adb wait-for-device
	echo "******************************"
	echo "* 6. Print out kernel message"
	adb shell cat /proc/kmsg
else
	echo "$AOSP_BOOT_FILE don't exist!!"
fi
