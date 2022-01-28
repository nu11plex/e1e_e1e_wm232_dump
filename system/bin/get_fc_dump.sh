#!/system/bin/sh
local dump_dtcm_time
echo "get ITCM_DTCM , unrd result is `unrd -g ITCM_DTCM`" > /dev/kmsg
#judge whether fc watch dog reset save the tcm
return_val=$(unrd -g ITCM_DTCM)
result=$(echo $return_val | grep "ITCM")
if [[ "$result" != "" ]]; then
	#judge whether itcm.dump exist
	echo "prepare to do ITCM dump" > /dev/kmsg
	if [ -f /blackbox/system/itcm.dump ]
	then
		file_size=$(ls -ld /blackbox/system/itcm.dump | busybox awk '{print $4}');
		echo "get old itcm.dump file size $file_size" > /dev/kmsg
		#160000 + 1D
		if [ $((file_size)) -ne 1441821 ]
		then
			unrd -g ITCM "/blackbox/system/itcm.dump"
			date >> /blackbox/system/itcm.dump
		fi
	else
		unrd -g ITCM "/blackbox/system/itcm.dump"
		date >> /blackbox/system/itcm.dump
	fi
	unrd -d ITCM
	unrd -d ITCM_DTCM
	echo "itcm dump finish" > /dev/kmsg
else
	echo "no need to do itcm dump" > /dev/kmsg
fi

result=$(echo $return_val | grep "DTCM")
if [[ "$result" != "" ]]; then
	echo "prepare to do DTCM dump" > /dev/kmsg
	dump_dtcm_time=$(unrd -g DUMP_DTCM_TIME)
	if [ $? -eq 0 ]; then
		echo "DUMP_DTCM_TIME exist, dump_dtcm_time=$dump_dtcm_time" > /dev/kmsg
		dump_dtcm_time=$(($dump_dtcm_time+1))
		if [ $dump_dtcm_time -gt 10 ]; then
			dump_dtcm_time=1
			echo "reset dump_dtcm_time=$dump_dtcm_time" > /dev/kmsg
		fi
	else
		echo "DUMP_DTCM_TIME not exist!" > /dev/kmsg
		dump_dtcm_time=1
	fi
	echo "write dtcm to /blackbox/system/ZDMP$dump_dtcm_time.DAT" > /dev/kmsg
	#get DTCM to store in ZDMP.DJI
	unrd -g DTCM "/blackbox/system/ZDMP$dump_dtcm_time.DAT"
	date >> /blackbox/system/ZDMP$dump_dtcm_time.DAT
	echo "ZDMP$dump_dtcm_time.DAT" > /blackbox/system/ZDMP.DJI
	unrd -s DUMP_DTCM_TIME "$dump_dtcm_time"

	unrd -d DTCM
	unrd -d ITCM_DTCM
	echo "dtcm dump finish" > /dev/kmsg
else
	echo "no need to do dtcm dump" > /dev/kmsg
fi

echo "fc itcmp/dtcm dump finish" > /dev/kmsg
