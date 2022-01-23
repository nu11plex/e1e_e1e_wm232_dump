#!/system/bin/sh

TX_ENGINE="wm232_pb"
LOG_LEVEL="3"

if [ -f /data/dji/camera_factory ]; then
    TX_ENGINE="lcdc"
    echo "starting camera service in factory mode"
fi

echo "IMX283\0" > /sys/module/rcam_dji/parameters/vs_sensor_name
/system/bin/dji_camera2 -e ${TX_ENGINE} -d ${LOG_LEVEL}
