#!/system/bin/sh

chk_sdcard_mount()
{
    #check sd card
    SDCARD_DIR=`df | busybox grep "/mnt/media_rw" | busybox awk '{print $1}'`
    SDCARD=`echo ${SDCARD_DIR:0:13}`
    echo $SDCARD
    if [ "$SDCARD" == "/mnt/media_rw" ]; then
       echo "test sdcard link success"
       return 0
    fi
    echo "no sdcard directory!!"
    return 1

}

usb_conn=`cat /sys/class/android_usb/android0/state`
if [ $usb_conn = "CONFIGURED" ];then
    echo "detach sd from PC"
    test_hal_storage -c "0 volume detach_pc"
    sleep 2
fi

chk_sdcard_mount
exit $?
