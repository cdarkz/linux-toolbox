#!/bin/sh
TFTPD_IP=192.168.1.254

cd /tmp
killall usbipd
rmmod usbip_host usbip_core
tftp -gr usbip-core.ko $TFTPD_IP
tftp -gr usbip-host.ko $TFTPD_IP
tftp -gr libusbip.so.0.0.1 $TFTPD_IP
ln -sf libusbip.so.0.0.1 libusbip.so.0
ln -sf libusbip.so.0.0.1 libusbip.so
tftp -gr usbip $TFTPD_IP
tftp -gr usbipd $TFTPD_IP
chmod a+x usbip usbipd
insmod ./usbip-core.ko
insmod ./usbip-host.ko
./usbipd -D
./usbip bind -b 4-1.1
cat /proc/kmsg
