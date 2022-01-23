#!/system/bin/sh

check_camera_fs()
{
    blkid -c /dev/null -s TYPE /dev/block/mmcblk0p19 | grep vfat
    if [ $? -eq 0 ]; then
        echo "detected vfat fs of camera, format it to exfat" > /dev/kmsg
        mkexfat -s 256 /dev/block/mmcblk0p19
    fi
}

if [ ! -f "/cali/camera_fs_checked" ]; then
    check_camera_fs
    date > /cali/camera_fs_checked
    busybox fsync /cali/camera_fs_checked
fi

start vold
