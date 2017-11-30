#!/bin/bash
EXT_HDD_NAME="Backup"
EXT_HDD_PATH="/media/${USER}/${EXT_HDD_NAME}"
DATE_DAY=`date +"%Y%m%d"`
SRC_DIR=(~/.thunderbird ~/Documents ~/Pictures ~/kermit_log /mnt/Desktop_server/kermit_log)
TARGET_NAME=("thunderbird_mail.tar" "home_Documents.tar" "home_Pictures.tar" "home_kermit_log.tar" "desktop_kermit.tar")
TARGET_PATH=${EXT_HDD_PATH}/P750ZM_backup/${DATE_DAY}
if [ -d ${EXT_HDD_PATH} ]; then
	echo "Start to backup to ${EXT_HDD_PATH}"
	/bin/mkdir -p ${TARGET_PATH}

	for i in "${!SRC_DIR[@]}"; do
		TARGET_TAR=${TARGET_PATH}/${TARGET_NAME[$i]}
		/bin/tar jcf ${TARGET_TAR}.bz2 -C $(dirname ${SRC_DIR[$i]}) $(basename ${SRC_DIR[$i]})
	done

	/usr/bin/rsync -arq ~/work_space ${TARGET_PATH}/

	# check target's free space, if it's under 300G, then remove the oldest folder to increase free space
fi

