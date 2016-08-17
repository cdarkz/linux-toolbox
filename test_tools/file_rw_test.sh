#!/bin/sh
# $1: times for test
# $2: size for r/w file (KB)
# $3: path for test

if [ $1 ]; then
	TESTCOUNT=$1
else
	TESTCOUNT=10
fi

if [ $2 ]; then
	TESTSIZE=$2
else
	TESTSIZE=1024
fi

if [ $3 ]; then
	TESTPATH=$3
else
	TESTPATH=/tmp
fi

SRCFILE=/tmp/src_test.file
DSTFILE=${TESTPATH}/dst_test.file

echo "R/W size ${TESTSIZE} for ${TESTCOUNT} tests on ${TESTPATH}"
if [ ! -d ${TESTPATH} ]; then
	echo "\"${TESTPATH}\" doesn't exist"
fi
if [ ! -w ${TESTPATH} -o ! -r ${TESTPATH} ]; then
	echo "\"${TESTPATH}\" could not be R/W"
fi

count=1
while [ ${count} -le ${TESTCOUNT} ]
do
	dd if=/dev/urandom of=${SRCFILE} bs=1K count=${TESTSIZE}
	sync
	SRCMD5=`md5sum ${SRCFILE} | cut -d' ' -f1`
	echo "SRC file \"${SRCFILE}\" md5sum ${SRCMD5}"

	cp -f ${SRCFILE} ${DSTFILE}
	sync
	DSTMD5=`md5sum ${DSTFILE} | cut -d' ' -f1`
	echo "DST file \"${DSTFILE}\" md5sum ${DSTMD5}"


	if [ "$SRCMD5"=="$DSTMD5" ]; then
		echo "${count}: SRC file and DST file are same"
	else
		echo "${count}: SRC file and DST file are different!!!"
		exit 1
	fi

	count=$(( ${count} + 1 ))
done
