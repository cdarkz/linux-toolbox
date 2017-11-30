#!/bin/bash
# $1: recovery git folder
target=${1%/}.git
if [ -e "$1" -a -d "$1" ]; then
	echo "Generate $target from $1"
	cp -rf $1 $target
	cd $target && git clean -dfx && git checkout -- . && cd -
	rsync --rsh='ssh -p12345' -av $target recovery@192.168.1.254:~/git_recovery/casper/
	rm -rf $target
fi
