# Define path
LOG_PATH=/blackbox/system
IMG=/data/upgrade/signimgs/recovery.img
IMG_TMP1=/dev/recovery1.img
IMG_TMP2=/dev/recovery2.img
recovery_node=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/recovery
SRC_PATH=/cache/recovery

# backup recovery log
# rename last_kmg.log to upgrade_last_kmsg
cp -f /cache/recovery/last_kmsg $LOG_PATH/upgrade_last_kmsg.log
cnt=`ls -l $SRC_PATH/last_kmsg.* | wc -l`
#echo $cnt
i=1
while [ $i -le $cnt ]
do
echo $i
cp -f $SRC_PATH/last_kmsg.$i $LOG_PATH/upgrade_last_kmsg_$i.log
let i=$i+1
done

cp -f /cache/recovery/log $LOG_PATH/upgrade_ota.log

# Check the update recovery log index
index=1
if [ -f $LOG_PATH/update_recovery_index ]; then
	local tmp=`cat $LOG_PATH/update_recovery_index`
	if [ 9 -le $tmp ]; then
		echo 1 > $LOG_PATH/update_recovery_index
	else
		let tmp+=1
		echo $tmp > $LOG_PATH/update_recovery_index
		index=$tmp
	fi
else
	echo 1 > $LOG_PATH/update_recovery_index
fi
update_log=$LOG_PATH/update_recovery_log$index

# Check if recovery.img exist.
if [ -f $IMG ]; then
	echo "Start recovery.img update flow." > $update_log
else
	echo "No need to update recovery.img, since /data/recovery.img not exist." > $update_log
	busybox sync
	exit 0
fi

# Set start recovery image update flag.
if [ -f $LOG_PATH/update_recovery_start ]; then
	echo "Already set start flag last time." >> $update_log
else
	#set a flag in /cache/update_recovery_start
	echo "Set start flag." >> $update_log
	touch $LOG_PATH/update_recovery_start
fi

# Get the 32MB truncated images and get the md5 checksum IMG_MD5_1
cp $IMG $IMG_TMP1
busybox truncate -c -s 32M $IMG_TMP1
IMG_MD5_1=`md5sum $IMG_TMP1 | busybox awk '{ print $1 }'`
echo "IMG_MD5_1" $IMG_MD5_1 >> $update_log

# Get the 32MB recovery partition images and get the md5 checksum IMG_MD5_2
busybox dd if=$recovery_node of=$IMG_TMP2 bs=1M count=32
IMG_MD5_2=`md5sum $IMG_TMP2 | busybox awk '{ print $1 }'`
echo "IMG_MD5_2" $IMG_MD5_2 >> $update_log
echo "Create temp image ready." >> $update_log

# Start update recovery.img flow.
if [ -f $IMG_TMP1 -a -f $IMG_TMP2 ]; then
	if [ "$IMG_MD5_1" != "$IMG_MD5_2" ]; then
		dji_fw_verify -n recovery $IMG_TMP1
		if [ 0 -eq $? ]; then
			echo "Recovery.img verify done." >> $update_log

			# Actually start to write recovery.img.
			echo "Start to write recovery.img." >> $update_log
			busybox dd if=$IMG_TMP1 of=$recovery_node bs=1M count=32

			# Dump the recovery partition image and check md5
			busybox dd if=$recovery_node of=$IMG_TMP2 bs=1M count=32
			IMG_MD5_2=`md5sum $IMG_TMP2 | busybox awk '{ print $1 }'`
			echo "IMG_MD5_2" $IMG_MD5_2 >> $update_log
			if [ "$IMG_MD5_1" != "$IMG_MD5_2" ]; then
				echo "recovery partition md5sum failure." >> $update_log
			else
				echo "recovery partition md5sum pass." >> $update_log
			fi
			rm -rf $IMG_TMP1 $IMG_TMP2
			echo "Write recovery.img done." >> $update_log
		else
			echo "Recovery.img verify failure." >> $update_log
		fi
	else
		echo "Partition is the same, no need to update recovery.img." >> $update_log
	fi
fi
rm $LOG_PATH/update_recovery_start
busybox sync
