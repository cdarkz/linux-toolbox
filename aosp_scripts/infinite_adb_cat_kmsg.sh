#!/bin/sh
adb root
adb wait-for-device

while [ 1 ]
do
	echo "=======loop"
	adb shell cat /proc/kmsg
	#adb wait-for-device
done
