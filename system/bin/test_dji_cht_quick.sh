#! /system/bin/sh

test_hal_storage -c "0 volume detach_pc"
sleep 1
stop dji_camera2

setprop dji.navigation_service 0


sleep 2

dji_cht -f -o -e wm232_pb -g emmc -F /system/etc/cht_cases_quick.conf
