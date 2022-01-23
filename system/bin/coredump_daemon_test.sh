#!/system/bin/sh

SYS_FOLDER="/blackbox/system/coredump"
DATA_FOLDER="/data/coredump"

if [ ! -d $SYS_FOLDER ]; then
	mkdir $SYS_FOLDER
fi

while [ true ]
do
	foldersize=`cd /data/coredump && du -s | busybox awk '{print $1}'`
	maxsize=$((1024*10))
	if [ $foldersize -gt $maxsize ]; then
		cp $DATA_FOLDER/* $SYS_FOLDER/
		rm $DATA_FOLDER/*
	fi
	sleep 10
done

