dump_dir=/data/dji/log/eagle_state

calc_filename()
{
	mkdir -p $dump_dir
	cd $dump_dir
	ls > /tmp/eagle_state_files
	file_num=`busybox wc -l /tmp/eagle_state_files | busybox awk '{ print $1}'`
	if [ $file_num == 0 ];then
		dump_file=$dump_dir/0
	else
		busybox sort -g /tmp/eagle_state_files > /tmp/eagle_state_files_sort
		cur_num=`busybox tail /tmp/eagle_state_files_sort -n 1`
		rm_file=$(($cur_num-50))	# keep latest 50 dump files
		if [ $rm_file -ge 0 ];then
			rm -rf $dump_dir/$rm_file
			sync
		fi
		let cur_num+=1
		dump_file=$dump_dir/$cur_num
	fi

	echo $dump_file
	touch $dump_file
}

check_dmesg()
{
	dmesg > /tmp/dmesg
#	grep -E 'LC1160|ath6k|hostapd' /tmp/dmesg >> $dump_file
#TODO: just dump all the dmesg to log file, add key pattens latter.
	cat /tmp/dmesg > $dump_file
}

check_dji_hdvt_gnd()
{
	ps | grep "dji_hdvt_gnd" >> $dump_file
}

check_dji_hdvt_uav()
{
	ps | grep "dji_hdvt_uav" >> $dump_file
}

check_dji_hdvt()
{
#	check hdvt_service
#	if [ $DEVICE_TYPE = "GND" ]; then
#		check_dji_hdvt_gnd
#	elif [ $DEVICE_TYPE = "UAV" ]; then
#		check_dji_hdvt_uav
#	fi
#TODO: in wm230 only add hdvt_uav, for cornerstone should add device check flow
	check_dji_hdvt_uav
}

check_cp_status()
{
	modem_info.sh cps >> $dump_file
	net_interface=`busybox ifconfig lmi42 | grep "UP"`
	if [ -n "$net_interface" ]; then
		modem_info.sh lmi42 | grep "send" >> $dump_file
		modem_info.sh lmi42 | grep "notbusy" >> $dump_file
	fi
	ps | grep "sdrs" >> $dump_file
}

check_dji_sys()
{
	ps | grep "dji_sys" >> $dump_file
}

check_dji_perception()
{
	ps | grep "dji_perception" >> $dump_file
}

check_dji_navigation()
{
	ps | grep "dji_navigation" >> $dump_file
}

check_dji_flight()
{
	ps | grep "dji_flight" >> $dump_file
}

check_dji_sw_uav()
{
	ps | grep "dji_sw_uav" >> $dump_file
}

check_dji_blackbox()
{
	ps | grep "dji_blackbox" >> $dump_file
}

check_dji_camera()
{
	ps | grep "dji_camera2" >> $dump_file
	ps | grep "dji_rcam" >> $dump_file
}

check_dji_network()
{
	ps | grep "dji_network" >> $dump_file
}

check_thermal_temp()
{
#TODO: change this flow to eagle specific flow
	temp=`cat /proc/driver/comip-thermal | grep 'last is' | busybox awk '{ print $15; }'`
	echo "DJI Eagle thermal temp is $temp" >> $dump_file
}

check_wifi_status()
{
	#es_event_cb_network_info
	#liveview channel switch status
	#hu_event_cb_network_info
	#remote control channel switch status
	#RTT
	#udt performance
	#hostapd
	#hostapd status
	logcat -v threadtime -d | grep -E 'es_event_cb_network_info|hu_event_cb_network_info|RTT' >> $dump_file
}

add_timestamp()
{
	echo >> $dump_file
	date >> $dump_file
}

main()
{
	calc_filename
	check_dmesg

	while [ 1 ]; do
		add_timestamp
		check_dji_hdvt
		check_dji_sys
		check_dji_perception
		check_dji_navigation
		check_dji_flight
		check_dji_sw_uav
		check_dji_blackbox
		check_dji_camera
		check_dji_network
#		check_cp_status
#		check_thermal_temp
#		check_wifi_status
		sync
		if [ x$1 == x ]; then
			sleep 30
		else
			sleep $1
		fi
	done
}

main $1
