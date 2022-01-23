#! /system/bin/sh

cam_pid=

cam_pid_query()
{
	cur_cam_pid=`ps | busybox awk '{if ($NF ~ /.*camera2/) print $2}'`
	echo $cur_cam_pid
}

cam_pid_reinit()
{
	loop=true
	while $loop; do
		cam_pid=`cam_pid_query`
		if [ "$cam_pid" != "" ]; then
			echo "Initialize camera pid is "$cam_pid
			loop=false
		else
			sleep 1
		fi

	done
}

cam_quit_monitor()
{
	cur_cam_pid=`cam_pid_query`
	if [ "$cur_cam_pid" != "$1" ]; then
		cam_pid_reinit
		echo "*****************camera reboot, pid change from["$1"] to ["$cam_pid"]*****************" >> $2
		return 0
	fi
}

logcat_file()
{
	logcat -b system -b crash *:I | busybox grep -v -e .*DSH.* -e .*channel_send.* -e .*event_send.* -e .*send_message.* >> $1 &
}

kill_sync()
{
    echo "Request to kill: "$1
    kill -9 $1
    ps $1 | busybox grep "logcat"
    while [ $? == 0 ]
    do
        ps $1 | busybox grep "logcat"
        if [ $? != 0 ]
        then
            echo "target process: $1 killed"
            break
        else
            kill -9 $1
            sleep 0.1
        fi
    done
}

#begin
if [ $# -lt 1 ]; then
	echo "help msg:"
	echo "\t"$0 "log_file_size[unit:bytes]"
	exit
fi

MAX_FILE_SIZE=$1
JOBPPID=$$
LOG_PATH=/blackbox/camera/log

mkdir -p $LOG_PATH

cam_pid_reinit

echo "==============Start to dump camera log==============" >> $LOG_PATH/cam_00.log

logcat_file $LOG_PATH/cam_00.log

while true
do
    cam_quit_monitor $cam_pid $LOG_PATH/cam_00.log

    file_size=`ls -al $LOG_PATH/cam_00.log | busybox awk '{print $4}'`
    if [ $file_size -gt $MAX_FILE_SIZE ]; then
        LOGCATPID=`busybox pgrep -l -P ${JOBPPID} | busybox grep logcat | busybox awk '{print $1}'`
        echo "Kill current logcat job: "$LOGCATPID
		#the grep process automatically exit after killing logcat
        kill_sync $LOGCATPID
        mv $LOG_PATH/cam_02.log $LOG_PATH/cam_03.log
        mv $LOG_PATH/cam_01.log $LOG_PATH/cam_02.log
        mv $LOG_PATH/cam_00.log $LOG_PATH/cam_01.log
        logcat_file $LOG_PATH/cam_00.log
    fi
    sleep 30
done
