#!/bin/sh
adb wait-for-device
adb root
adb wait-for-device
sleep 5

while [ 1 ]
do
	echo "=======loop"
	adb shell cat /proc/kmsg || exit 1
done
