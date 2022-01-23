### This script is used to correct system time
### after each reboot. It saves system time every
### second, and load the time once it is started.
### This can avoid jumping back to 1980, which mess
### up sd card data.

#!/system/bin/sh

RecordFile=/data/dji/time_record

# judge if we have a pigeon subnode
let pigeon_exist=`adb devices | grep pigeon | wc -l`

# load system time if it exist
if [ -f $RecordFile ]
then
    if [ $pigeon_exist -ne 0 ]; then
        last_date="$(< $RecordFile)"
        adb shell "busybox date -s \"$last_date\""
    fi
    busybox date -s "$(< $RecordFile)"
fi

let count=0
while [ 1 ]
do
    busybox date +"%Y-%m-%d %H:%M:%S" > $RecordFile
    echo "<7> `date`" >> /dev/kmsg
    sleep 60

    if [ $pigeon_exist -eq 0 ]; then
        let pigeon_exist=`adb devices | grep pigeon | wc -l`
    fi

    if [ $pigeon_exist -ne 0 -a $(($count%2)) -eq 0 ]; then
        cur_time=`busybox date +"%Y-%m-%d %H:%M:%S"`
	    adb shell "busybox date -s \"$cur_time\""
    fi

    let count=count+1
done


