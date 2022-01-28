#!/system/bin/sh

# Author: raymone.liu
# Created time: 6/21/2018

echo "Start copy_log script!"


timestamp=$(date +%Y%m%d_%H%M%S)
flyctrl_name="flyctrl"
flyctrl_suf=".DAT"
name_pre=""

function MakeDir 
 { 
    if [[ $# -ne 1 ]] 
    then 
        return 1 
    fi 
	
	model="$1"
	for i in $(seq 3); do
		mkdir -p /storage/sdcard0/AutoFly_ALL_${timestamp}/${model}
		if [ $? -eq 0 ]; then
			echo "mkdir ${model} Success"
			break
		else
			if [ $i -eq 3 ]; then
				echo "mkdir ${model} Fail, exit status $?"
				echo "Please Reboot and Retry!"
				exit 2
			else
				sleep 3
			fi
		fi
	done
 }

 
 function CopyLog
 {
	model="$1"
	if [ $# -eq 2 ]; then
		log_name="$2"
	fi
	
	for i in $(seq 3); do
		if [ $# -eq 1 ]; then
			cp -r /blackbox/${model} /storage/sdcard0/AutoFly_ALL_${timestamp}/
		elif [ $# -eq 2 ]; then
			cp -r /blackbox/${model}/${log_name} /storage/sdcard0/AutoFly_ALL_${timestamp}/${model}/${log_name}
		else
			echo "please check input params!"
		fi
		
		if [ $? -eq 0 ]; then
			echo "cp ${model} Success"
			break
		else
			if [ $i -eq 3 ]; then
				echo "cp ${model} Failure, exit status $?"
				echo "Please Reboot and Retry!"
				exit 2
			else
				sleep 3
			fi
		fi
	done
 }


function DelLog
 {
	echo "start delete old logs"
	filenum=`find /storage/sdcard0/ -maxdepth 1 -type d -name 'AutoFly_ALL_*'|wc -l`
	while [ ${filenum} -gt 2 ]
		do
		rm -rf /storage/sdcard0/$(ls /storage/sdcard0/ |grep 'AutoFly_ALL_'| head -1)
		filenum=`find /storage/sdcard0/ -maxdepth 1 -type d -name 'AutoFly_ALL_*'|wc -l`
		echo "There is ${filenum} directories"
	done
 }

 function GetFlyctrlName
 {
	echo "getting flyctrl name!"
	fly_log_num=$1
	if [ ${#fly_log_num} -eq 1 ];then
		name_pre="FLY00"
	elif [ ${#fly_log_num} -eq 2 ]; then
		name_pre="FLY0"
	elif [ ${#fly_log_num} -eq 3 ]; then
		name_pre="FLY"
	else
		echo "wrong latest number!"
	fi
 }
 
 
#keep lastest 2 logs
DelLog
#mkdir and cp log for eagle 
for model in  system camera dji_flight autoflight; do
	MakeDir ${model}
	CopyLog ${model}
	
done

for model in flyctrl dji_perception navigation; do
	MakeDir ${model}
	num=$(cat /blackbox/${model}/latest)
	log_name="${num}"
	diff=1
	echo "latest ${model} is :"
	echo ${num}

	if [ "${model}" = "${flyctrl_name}" ]; then
		if [ ${num} -gt 1 ]; then
			echo "copy latest 2 flyctrl log"
			num_less=`expr ${num} - ${diff}`
			echo ${num_less}
			GetFlyctrlName ${num_less}
			log_name_less=${name_pre}${num_less}${flyctrl_suf}
			echo ${log_name_less}
			CopyLog ${model} ${log_name_less}
		fi

		GetFlyctrlName ${num}
		log_name=${name_pre}${num}${flyctrl_suf}
		echo ${log_name}
	fi

	CopyLog ${model} ${log_name}
done



# version_eagle=$(getprop dji.build.version)
