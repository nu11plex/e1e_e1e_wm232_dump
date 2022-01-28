#! /system/bin/sh

test_hal_storage -c "0 volume detach_pc"

sleep 1

start dji_camera2

setprop dji.navigation_service 0


sleep 5

dji_cst -d 3 -p -f -s 9 -F /system/etc/perf_cst_cases.conf

