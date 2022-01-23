#!/system/bin/sh

echo "set up usb serial number"

if [ $# == 1 ]; then
    write_udc 2 off
    sleep 1
    echo $1 > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
    echo $1 > /factory_data/usb_serial
    write_udc 2 on
    sleep 5
else
    if [ -f /factory_data/usb_serial ]; then
        write_udc 2 off
        sleep 1
        ser=$(cat /factory_data/usb_serial)
        echo $ser > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
        write_udc 2 on
        sleep 5
    fi
fi

echo "finish set up usb serial"
