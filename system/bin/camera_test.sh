#!/system/bin/sh

usage()
{
    echo "usage: camera_test.sh <camera_power_on/camera_power_off/...>"
}

if [ $# -gt 1 -o $# == 0 ];then
    usage
    exit 1
fi

if [ $1 == "camera_power_on" ]; then
    echo "camera_power_on"
    echo "7 1" >/sys/devices/platform/soc/f0a00000.apb/f0a10000.i2c0/i2c-0/0-0048/f0a10000.i2c0\:tps65961@48\:on_off_ldo/state
elif [ $1 == "camera_power_off" ]; then
    echo "camera_power_off"
    echo "7 0" >/sys/devices/platform/soc/f0a00000.apb/f0a10000.i2c0/i2c-0/0-0048/f0a10000.i2c0\:tps65961@48\:on_off_ldo/state
elif [ $1 == "camera_service_on" ]; then
    echo "camera_service_on"
    setprop dji.camera_service 1
elif [ $1 == "camera_service_off" ]; then
    echo "camera_service_off"
    setprop dji.camera_service 0
elif [ $1 == "camera_service_restart" ]; then
    echo "camera_service_off"
    setprop dji.camera_service 0
    setprop dji.camera_service 1
elif [ $1 == "i2c_pin_off" ]; then
    echo "i2c pin ---> gpio input high Z"
    busybox devmem 0xf0a410b4 32 0x1
    busybox devmem 0xf0a410b8 32 0x1
    result=`busybox devmem 0xf0a09004`
    bytes=${result##*0x}
    bitmask=$((1 << 13))
    bit_result=$((16#$bytes&$bitmask))
    if [ $bit_result == 1 ]; then
        echo "ERROR: gpio1_13 is not input"
    fi

    bitmask=$((1 << 14))
    bit_result=$((16#$bytes&$bitmask))
    if [ $bit_result == 1 ]; then
        echo "ERROR: gpio1_14 is not input"
    fi
elif [ $1 == "i2c_pin_on" ]; then
    echo "gpio input high Z ---> i2c pin"
    busybox devmem 0xf0a410b4 32 0x20007
    busybox devmem 0xf0a410b8 32 0x20007
elif [ $1 == "delete_cali_file" ]; then
    echo "delete_cali_file"
    rm /factory_data/camera/* -rf
    rm /cali/camera/cali/* -rf
elif [ $1 == "check_mipi_error" ]; then
    echo "check mipi error, please run this script and then pull data/dji/kmsg.log by adb or sdk"
    dmesg -c > /data/dji/kmsg.log
fi
