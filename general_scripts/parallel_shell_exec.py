#!/usr/bin/env python
import os, sys
import subprocess

def usage():
    print('Usage: ' + sys.argv[0] + ' <cmds file>')

# check parameter
ARGC = len(sys.argv)
if ARGC != 2:
    usage()
    exit(1)

# parse commands list file
PROC_LIST = []
FILE = open(sys.argv[1], 'r')
for line in FILE:
    # execute command
    PROC_LIST.append(subprocess.Popen(line.strip(), shell = True))
FILE.close()

# check whether Ctrl-c pressed
while True:
    try:
        for proc in PROC_LIST:
            if not proc.pid:
                print('Error on process')
    except KeyboardInterrupt:
        for proc in PROC_LIST:
            proc.terminate()
        exit(0)
