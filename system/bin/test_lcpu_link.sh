#!/system/bin/sh

stop dji_camera2
sleep 1

result=`i2cget -f -y 6 0x05 0x00`

if [ "$result" == "0x00" ]; then
    echo "test lcpu link success"
    start dji_camera2
    exit 0
else
    echo "test lcpu link faild"
    start dji_camera2
    exit 1
fi
