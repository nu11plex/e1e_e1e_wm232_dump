#!/system/bin/sh
# ------------This script is used to copy  log to sdcard-------------

echo "----------start log copy to sdcard------------"

if [ $# -ne 2 ]; then
    echo "please enter xx.sh module_name pre_or_now"
    echo "module_name: all camera system flyctrl perception navigation s1"
    echo "pre_or_now: pre  now"
    exit 1
fi

module_name=$1
log_index=$2

#1. judge the sdcard is on or not
test_sdcard_link.sh
if [ $? != 0 ];then
    echo "the sdcard is not in the board."
    exit 1
fi

# 2. parse the input data
case $module_name in
    "all")
        echo "copy all the log"
        index={camera,flyctrl,dji_flight,fatal,kmsg,sdrs_log,sdrs_serial,navigation,perception,ss_dsp}
        ;;
    "camera")
        echo "copy camera log"
        index={camera,fatal,kmsg}
        ;;
    "system")
        echo "copy system log."
        index={fatal,kmsg}
        ;;
    "flyctrl")
        echo "copy flyctrl log"
        index={flyctrl,dji_flight,fatal,kmsg}
        ;;
    "s1")
        echo "copy s1 log"
        index={fatal,kmsg,sdrs_log,sdrs_serial}
        ;;
    "navigation")
        echo "copy navigation log"
        index={fatal,kmsg,sdrs_lognavigation}
        ;;
    "perception")
        echo "copy perception log"
        index={fatal,kmsg,perception,ss_dsp}
        ;;
    *)
        echo "please point out the items.."
        exit 4
        ;;
esac

#3. create the dest direct
time_prefix=`date +%Y%m%d%H%M%S`
time_prefix2=`cat /proc/uptime | busybox awk '{print $1}' | busybox awk -F "." '{print $1}'`
save_dic=/storage/sdcard0/copy_log/"$module_name_$time_prefix"_"$time_prefix2"/
echo "create path $save_dic"
mkdir -p $save_dic

#4. copy log
for i in $index; do
	echo "####################ctrl $i################################"
	log_to_dest_direct $i $log_index $save_dic
	if [ $? != 0 ];then
	    echo "log_to_dest_direct faild."
	    exit 1
	fi
done

exit 0
