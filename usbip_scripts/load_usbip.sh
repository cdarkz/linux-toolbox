#!/bin/sh
cd /tmp
killall usbipd
rmmod usbip_host usbip_core
tftp -gr usbip-core.ko 192.168.1.254
tftp -gr usbip-host.ko 192.168.1.254
tftp -gr libusbip.so.0.0.1 192.168.1.254
ln -sf libusbip.so.0.0.1 libusbip.so.0
ln -sf libusbip.so.0.0.1 libusbip.so
tftp -gr usbip 192.168.1.254
tftp -gr usbipd 192.168.1.254
chmod a+x usbip usbipd
insmod ./usbip-core.ko
insmod ./usbip-host.ko
./usbipd -D
./usbip bind -b 4-1.1
cat /proc/kmsg
