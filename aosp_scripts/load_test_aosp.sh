#!/bin/bash
# $1: device codename

# DEVICE_NAME:
#  Nexus 5X = bullhead
#  Nexus 6P = angler
#  Nexus 9 = flounder
#  Nexus 5 = hammerhead
DEVICE_NAME=flounder
if [ -n $1 ]; then
	DEVICE_NAME=$1
fi

AOSP_DIR=/mnt/SATA_HDD/android/aosp_marshmallow
AOSP_BOOT_FILE=${AOSP_DIR}/out/target/product/${DEVICE_NAME}/boot.img
case $DEVICE_NAME in
    "bullhead")
	ROOT_FOLDER=/home/cdarkz/work_space/android/root_recovery/CF-Auto-Root-bullhead-bullhead-nexus5x
	;;
    "angler")
	ROOT_FOLDER=/home/cdarkz/work_space/android/root_recovery/CF-Auto-Root-angler-angler-nexus6p
	;;
    "flounder")
	ROOT_FOLDER=/home/cdarkz/work_space/android/root_recovery/CF-Auto-Root-flounder-volantis-nexus9
	;;
    "hammerhead")
	ROOT_FOLDER=/home/cdarkz/work_space/android/root_recovery/CF-Auto-Root-hammerhead-hammerhead-nexus5
	;;
    *)
	echo "Error DEVICE_NAME!!"
	exit 1
	;;
esac

check_state() {                                                                           
	adb_state=`adb get-state`
	fb_state=`fastboot devices`
	if [ "${adb_state}" == "device" ]; then
		return 1;
	elif [ "${fb_state}" != "" ]; then
		return 2;
	fi

	return 0
}

if [ -d ${AOSP_DIR} ]; then
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
	echo fastboot flash boot ${AOSP_BOOT_FILE}
	fastboot flash boot ${AOSP_BOOT_FILE}
	fastboot reboot
	adb wait-for-device

	echo "******************************"
	echo "* 3. Do Root *"
	adb reboot bootloader
	echo "Enter ${ROOT_FOLDER}"
	cd ${ROOT_FOLDER}
	sh root-linux.sh
	cd -
	adb wait-for-device
	sleep 35
	adb wait-for-device

	echo "******************************"
	echo "* 4. Print kernel message *"
	adb root
	adb wait-for-device
	adb shell cat /proc/kmsg
else
	echo "${AOSP_DIR} don't exist!!"
fi
