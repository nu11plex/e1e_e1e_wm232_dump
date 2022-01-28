#! /system/bin/sh
stop dji_perception
sleep 2
stop dji_navigation
sleep 2
stop ss_dsp_manager
sleep 5
dji_ppt -P 3 -f -d 3 -L /system/etc/ppt_cases.conf

sleep 1

start dji_camera2
