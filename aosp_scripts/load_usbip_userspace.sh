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

USBIP_USERSPACE_DIR=/home/cdarkz/work_space/usbip/usbip_git/userspace
case $DEVICE_NAME in
    "bullhead")
	RECOVERY_IMAGE=/home/cdarkz/work_space/android/root_recovery/twrp-3.0.2-0-bullhead.img
	;;
    "angler")
	RECOVERY_IMAGE=/home/cdarkz/work_space/android/root_recovery/twrp-3.0.2-0-angler.img
	;;
    "flounder")
	RECOVERY_IMAGE=/home/cdarkz/work_space/android/root_recovery/twrp-3.0.2-0-flounder.img
	;;
    "hammerhead")
	RECOVERY_IMAGE=/home/cdarkz/work_space/android/root_recovery/twrp-3.0.0-0-hammerhead.img
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
	elif [ "${adb_state}" == "recovery" ]; then
		return 3;
	fi

	return 0
}

if [ -d ${USBIP_USERSPACE_DIR} ]; then
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
	echo "* 2. Boot to recovery image *"
	if [ -e ${RECOVERY_IMAGE} ]; then
		adb reboot bootloader
		echo fastboot boot ${RECOVERY_IMAGE}
		fastboot boot ${RECOVERY_IMAGE}
		sleep 30
		check_state
		if [ $? != 3 ]; then
			echo "Can not into recovery mode"
			exit 1
		fi
	else
		echo "Recovery image doesn't exist (${RECOVERY_IMAGE})"
		exit 1
	fi

	echo "******************************"
	echo "* 3. Install usbip userspace *"
	if [ -d ${USBIP_USERSPACE_DIR}/src/.libs ] && [ -d ${USBIP_USERSPACE_DIR}/libsrc/.libs ]; then
		adb shell twrp mount /system
		adb push ${USBIP_USERSPACE_DIR}/src/.libs/usbip /system/xbin/usbip
		adb shell chown root:shell /system/xbin/usbip
		adb shell chmod 0755 /system/xbin/usbip
		adb push ${USBIP_USERSPACE_DIR}/libsrc/.libs/libusbip.so.0.0.1 /system/usr/lib/libusbip.so
		adb push ${USBIP_USERSPACE_DIR}/libsrc/.libs/libusbip.so.0.0.1 /system/usr/lib/libusbip.so.0
		adb push ${USBIP_USERSPACE_DIR}/libsrc/.libs/libusbip.so.0.0.1 /system/usr/lib/libusbip.so.0.0.1
		adb shell chown root:shell /system/usr/lib/libusbip.so*
		adb shell chmod 0755 /system/usr/lib/libusbip.so*
		adb reboot
		sleep 30
		adb wait-for-device
	else
		echo "usbip doesn't exist (${USBIP_USERSPACE_DIR})"
		exit 1
	fi
else
	echo "${USBIP_USERSPACE_DIR} don't exist!!"
fi
