#!/bin/bash

# re-connect kermit
user=`whoami`
echo "screen for $user"
for screenfull in "/var/run/screen/S-$user"/*;
do
	screenid=`basename ${screenfull} | cut -d. -f1`
	if [ `cat /proc/${screenid}/cmdline | grep -c kermit` == '1' ]; then
		#echo "find kermit at ${screenid}"
		# exit from kermit
		screen -x ${screenid} -X stuff '\034\103'
		screen -x ${screenid} -X stuff '\003'
		screen -x ${screenid} -X stuff 'exit\015'
		sleep 1
	fi
done

# remove zero size file
find ~/kermit_log -size 0 | xargs rm

sleep 3
screen -d -m -S ttyUSB kermit -y ~/kermit_log/kermrc_usb
screen -d -m -S ttyS kermit

# archive kermit logs
archive_mon=$(date --date="-12 month" +%Y%m)

if [[ ! -z `/bin/ls ~/kermit_log/${archive_mon}*.txt 2>/dev/null` ]]; then
	cd ~/kermit_log
	/bin/tar jcvf ${archive_mon}xx.tar.bz2 ${archive_mon}*.txt && /bin/rm -f ${archive_mon}*.txt
fi
