#!/bin/bash

for screenfull in "/var/run/screen/S-$USER"/*;
do
	screenid=`basename ${screenfull} | cut -d. -f1`
	if [ `cat /proc/${screenid}/cmdline | grep -c kermit` == '1' ]; then
		#echo "find kermit at ${screenid}"
		# exit from kermit
		screen -x ${screenid} -X stuff '\034\103'
		screen -x ${screenid} -X stuff '\003'
		screen -x ${screenid} -X stuff 'exit\015'
	fi
done

screen -d -m kermit -y ~/kermit_log/kermrc_usb
screen -d -m kermit
