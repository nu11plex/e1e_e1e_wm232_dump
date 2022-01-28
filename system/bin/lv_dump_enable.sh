#! /system/bin/sh

### BEGIN INFO
# Used to capture liveview dump
# Provides:    Dennis.zhang
### END INFO

kill_sync()
{
    echo "Request to kill: $1"
    kill -9 $1
    ps $1 | busybox grep "tcpdump"
    while [ $? == 0 ]
    do
        ps $1 | busybox grep "tcpdump"
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

timeout=$1
LOGDIR="/blackbox/lvdump"
LOGCTRLDIR="/data/"
INDEX_FILE="index"
H264_ENABLE_FILE="venc_dump"
index=0
if [ ! -d $LOGDIR ]; then
    mkdir -p $LOGDIR
fi


if [ -f "$LOGCTRLDIR/$H264_ENABLE_FILE" ]; then
    echo "enable action: delete before dump config"
    rm $LOGCTRLDIR/$H264_ENABLE_FILE
    sleep 1
    sync
fi

if [ "X$timeout" == "X" ]; then
    timeout=120
    echo "enable action: no timeout was setting, default is 120s"
fi

if [ -f "$LOGDIR/$INDEX_FILE" ]; then
    index=`cat $LOGDIR/$INDEX_FILE`
    if [ $? != 0 ]; then
        echo "$LOGDIR/$INDEX_FILE no exist"
    else
        index=`busybox expr $index + 1`
    fi
fi

echo "enable action: dump h264 enable index:$index"
time=`date +%Y%m%d_%H%M%S`
echo -n "$LOGDIR/h264_dump_${index}_$time.log" > "$LOGCTRLDIR/$H264_ENABLE_FILE"
echo -n "$index" > $LOGDIR/$INDEX_FILE
sync

echo "dump ip packet enable"
tcpdump -i wlan0 -s 256 -w $LOGDIR/tcpdump_${index}_$time.pcap 1>/dev/null &
JOBPPID=$$
loopcnt=0
while true
do
    TCPDUMPPID=`busybox pgrep -l -P ${JOBPPID} | busybox grep tcpdump | busybox awk '{print $1}'`
    if [ $loopcnt -gt $timeout ]; then
        echo "Kill current job: ${TCPDUMPPID}"
        kill_sync $TCPDUMPPID
        rm $LOGCTRLDIR/$H264_ENABLE_FILE
        sync
        exit 0
    fi
    if [ -z "$TCPDUMPPID" ]; then
        time=`date +%Y%m%d_%H%M%S`
        tcpdump -i wlan0 -s 256 -w $LOGDIR/tcpdump_${index}_$time.pcap 1>/dev/null &
    fi
    sleep 1
    loopcnt=`busybox expr $loopcnt + 1`
done

