#!/system/bin/sh

set -x
test_hal_storage -c "0 volume detach_pc"
sleep 3
busybox dd if=/dev/zero of=/camera/test.bin bs=1M count=10
orig_md5val=busybox md5sum /camera/test.bin | busybox awk '{print $1}'
busybox tar -czf /camera/test.tar.gz camera/test.bin

rm /camera/test.bin
busybox tar -xzf /camera/test.tar.gz
new_md5val=busybox md5sum /camera/test.bin | busybox awk '{print $1}'
if [[ $new_md5val -ne $orig_md5val ]]; then
        echo "new_md5val doesn't match orig_md5val"
        exit 1
fi

cp /camera/test.bin /blackbox/test.bin
new_md5val=busybox md5sum /blackbox/test.bin | busybox awk '{print $1}'
if [[ $new_md5val -ne $orig_md5val ]]; then
        echo "Blackbox1 new_md5val doesn't match orig_md5val"
        exit 1
fi
busybox tar -czf /blackbox/test.tar.gz blackbox/test.bin
rm /blackbox/test.bin
busybox tar -xzf /blackbox/test.tar.gz
new_md5val=busybox md5sum /blackbox/test.bin | busybox awk '{print $1}'
if [[ $new_md5val -ne $orig_md5val ]]; then
        echo "Blackbox2 new_md5val doesn't match orig_md5val"
        exit 1
fi
