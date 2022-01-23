#! /system/bin/sh

### BEGIN INFO
# Used to capture liveview dump
# Provides:    Dennis.zhang
### END INFO

is_enable=$1
timeout=$2
LOGDIR="/blackbox/lvdump"
LOGCTRLDIR="/data/"
H264_ENABLE_FILE="venc_dump"

#for disable action kill tcpdump and delete h264 dump control file

echo "disable action: delete h264 control file"
rm $LOGCTRLDIR/$H264_ENABLE_FILE
sync
loop_cnt=0
echo "try to kill dump process"
while [ $loop_cnt -lt 10 ]; do
    if [ `busybox ps | busybox grep "lv_dump_enable" | busybox grep -c -v grep` -gt 0 ]; then
        pid=`busybox ps | busybox grep "lv_dump_enable" | busybox grep -v "grep" | busybox awk -F ' ' '{print $1; exit}'`
        if [ -n "$pid" ]; then
          echo "kill process dump process $pid"
          kill -2 "$pid"
        fi
    else
        break
    fi
    loop_cnt=`busybox expr $loop_cnt + 1`
    echo "loop cnt $loop_cnt"
done

loop_cnt=0
echo "try to kill tcpdump process"
while [ $loop_cnt -lt 10 ]; do
    if [ `busybox ps | busybox grep "tcpdump" | busybox grep -c -v grep` -gt 0 ]; then
        pid=`busybox ps | busybox grep "tcpdump" | busybox grep -v "grep" | busybox awk -F ' ' '{print $1; exit}'`
        if [ -n "$pid" ]; then
          echo "kill process tcpdump process $pid"
          kill -2 "$pid"
        fi
    else
        break
    fi
    loop_cnt=`busybox expr $loop_cnt + 1`
    echo "loop cnt $loop_cnt"
done
exit 0


