#!/system/bin/sh
# lk log is stored at unrd, it will store last 5 logs,
# named from lk_log_0 to lk_log_4, lk_log_0 is the latest one
max_log_num=5
lk_log_dir=/blackbox/system
lk_cur_log=$(unrd -g lk_log_num)
saved_log_num=0

# extract lk log to tmp file
for i in $(seq 1 $max_log_num)
do
	unrd -l lk_log_$i

	if [ $? -eq 0 ];then
		cur_lk_tag_index=`expr \( $max_log_num + $lk_cur_log - $i \) % $max_log_num `
		unrd -g lk_log_$i > $lk_log_dir/lk_log_$cur_lk_tag_index.tmp
		date >> $lk_log_dir/lk_log_$cur_lk_tag_index.tmp
		unrd -d lk_log_$i
		saved_log_num=`expr $saved_log_num + 1`
	fi
done

# move current log file to end
if [ $saved_log_num -lt $max_log_num ];then
	moved_logs=`expr $max_log_num - $saved_log_num - 1`
	for i in $(seq $moved_logs -1 0)
	do
		if [ -f $lk_log_dir/lk_log_$i.log ];then
			mv $lk_log_dir/lk_log_$i.log $lk_log_dir/lk_log_$(expr $i + $saved_log_num).log
		fi
	done
fi

# move tmp file
for i in $(seq 0 $(expr $saved_log_num - 1))
do
	if [ -f $lk_log_dir/lk_log_$i.tmp ]; then
		mv $lk_log_dir/lk_log_$i.tmp $lk_log_dir/lk_log_$i.log
	fi
done

unrd -s lk_log_num 0
