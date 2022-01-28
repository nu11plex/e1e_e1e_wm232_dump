#!/system/bin/sh

cpu_md5_check.sh
if [ $? -ne 0 ]; then
        echo "Bad chip: MD5"
        exit 1
fi

ddr_test.sh
if [ $? -ne 0 ]; then
        echo "Bad chip: DDR"
        exit 1
fi

emmc_test.sh
if [ $? -ne 0 ]; then
        echo "Bad chip: EMMC"
        exit 1
fi

sd_test.sh
if [ $? -ne 0 ]; then
        echo "Bad chip: SD"
        exit 1
fi

usb_test.sh
if [ $? -ne 0 ]; then
        echo "Bad chip: USB"
        exit 1
fi
