#! /system/bin/sh

log_head_file="/data/head.bin"
log_bb_num_file="/blackbox/dji_blackbox/latest"
log_split_file="/data/gimbal_record.bin"
log_output_file="/data/gimbal_record.dat"

# 1. Checkout if head.bin exist.
if [ ! -f "$log_head_file" ]; then
	echo "missing head.bin..."
	exit 1
fi

# 2. Split gimbal log from *.bb
log_bb_file=$(cat $log_bb_num_file).bb
#echo $log_bb_file

dji_bb_spliter -i 7 -o $log_split_file /blackbox/dji_blackbox/$log_bb_file

cat $log_head_file $log_split_file > $log_output_file

rm $log_split_file

ls -al /data/gimbal*
