#!/system/bin/sh

stop logd
stop dji_v1_events

pid=`ps | grep logd | busybox awk '{print $2}'`

if [ "$pid"x != ""x ]; then
	kill $pid
fi

pid=`ps | grep logcat | busybox awk '{print $2}'`
for pid_num in $pid; do
	kill $pid_num
done
