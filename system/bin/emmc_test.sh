#!/system/bin/sh

set -x
test_hal_storage -c "0 volume detach_pc"
sleep 3
echo "EMMC test start" > /data/iostat.log
busybox iostat -m 1 -t >> /data/iostat.log &
busybox dd if=/dev/zero of=/camera/test.bin bs=1M count=1024 >> /data/iostat.log
rm /camera/test.bin
busybox dd if=/dev/zero of=/camera/test.bin bs=1M count=1024 >> /data/iostat.log
rm /camera/test.bin
echo "EMMC test end"  >> /data/iostat.log
exit 0
