#!/bin/bash
# $1: git repo source name
name=${1%.*}
repo=${name}.gitrepo
target=`grep -o '~/git-cloud[^"]*' $1/.git/config`
target_s=${target//\~/$HOME}
rm -rf $repo
if [ -e "$1" -a -d "$1" -a -n "$target_s" ]; then
	echo "Copy from git repo $repo to $target_s"
	git clone --bare $1 $repo
	cp -rf $repo $target_s
	rm -rf $repo
fi
