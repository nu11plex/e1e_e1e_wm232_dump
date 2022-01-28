#!/system/bin/sh

set -x
test_hal_storage -c "0 volume detach_pc"
sleep 3
echo "SD card test start" > /data/iostat.log
busybox iostat -m 1 -t >> /data/iostat.log &
busybox dd if=/dev/zero of=/storage/sdcard0/test.bin bs=1M count=1024 >> /data/iostat.log
rm /storage/sdcard0/test.bin
busybox dd if=/dev/zero of=/storage/sdcard0/test.bin bs=1M count=1024 >> /data/iostat.log
rm /storage/sdcard0/test.bin
echo "SD card test end"  >> /data/iostat.log
