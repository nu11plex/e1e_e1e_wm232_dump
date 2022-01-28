JOBPPID=$$
echo $JOBPPID

kill_sync()
{
    echo "Request to kill: $1"
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

for line in `busybox ps -T | grep start_high_consump.sh | busybox awk '{ print $1 }'`
do
	if [ $line -lt $JOBPPID ];then
		echo "high consumption pid is $line"
		kill_sync $line
	fi
done

pid=`busybox ps -T | grep dji_wm230_camera | busybox sed -n '1p' | busybox awk '{ print $1 }'`
echo "camera pid is $pid"
kill_sync $pid

pid=`busybox ps -T | grep dji_codec_aging.sh | busybox sed -n '1p' | busybox awk '{ print $1 }'`
echo "codec pid is $pid"
kill_sync $pid

sleep 1
setprop dji.camera_service 0
sleep 1
setprop dji.camera_service 1
sleep 1
