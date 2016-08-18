#!/bin/sh
# $1: repeat times for test
# $2: size for r/w file (KB)
# $3: number of files to do test
# $4: path for test

function usage() {
	echo "$1 <repeat> <size> <number of files> <path>"
}

if [ $# -ne 4 ]; then
	usage $0
	exit 1
fi

TESTCOUNT=$1
TESTSIZE=$2
TESTNUMBER=$3
TESTPATH=$4

SRCFILE=/tmp/src_test.file
DSTFILE=${TESTPATH}/dst_test.file

echo "R/W size ${TESTSIZE} for ${TESTCOUNT} tests on ${TESTPATH}"
# check parameter
if [ ! -d ${TESTPATH} ]; then
	echo "\"${TESTPATH}\" doesn't exist"
fi
if [ ! -w ${TESTPATH} -o ! -r ${TESTPATH} ]; then
	echo "\"${TESTPATH}\" could not be R/W"
fi

count=1
while [ ${count} -le ${TESTCOUNT} ]
do
	number=1
	while [ ${number} -le ${TESTNUMBER} ]
	do
		RSRCFILE=${SRCFILE}.${number}
		RDSTFILE=${DSTFILE}.${number}
 
		dd if=/dev/urandom of=${RSRCFILE} bs=1K count=${TESTSIZE}
		sync
		SRCMD5=`md5sum ${RSRCFILE} | cut -d' ' -f1`
		echo "SRC file \"${RSRCFILE}\" md5sum ${SRCMD5}"

		cp -f ${RSRCFILE} ${RDSTFILE}
		sync
		DSTMD5=`md5sum ${RDSTFILE} | cut -d' ' -f1`
		echo "DST file \"${RDSTFILE}\" md5sum ${DSTMD5}"

		if [ "${SRCMD5}"=="${DSTMD5}" ]; then
			echo "${count}.${number}: SRC file and DST file are same"
		else
			echo "${count}.${number}: SRC file and DST file are different!!!"
			exit 1
		fi

		number=$(( ${number} + 1 ))
	done

	count=$(( ${count} + 1 ))
done
