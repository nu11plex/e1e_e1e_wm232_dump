#!/system/bin/sh

e1e_product()
{
	cat /proc/cmdline | grep "mp_state=production"
	local pro_ret=$?
	return $pro_ret
}

# wait cali partition mount for 5s
i=50
while [ $i -gt 0 ]
do
	mount | grep cali
	if [ $? -eq 0 ]; then
		break
	else
		sleep 0.1
		i=$(($i-1))
	fi
done

if [ $i -eq 0 ]; then
	echo "cali partition mount timeout!!" > /dev/kmsg
fi

if [ -f /cali/usb_serial_qa ]; then
	cmdline=$(cat /proc/cmdline)
	cmdline=${cmdline#*chip_sn=}
	chip_sn=${cmdline% board_sn*}
	echo $chip_sn > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
fi

e1e_product
is_eng=$?

echo "enable usb gadget, is_eng: $is_eng" > /dev/kmsg

if [ $is_eng -eq 0 ]; then
	setprop sys.usb.config none
	setprop sys.usb.config rndis,mass_storage,bulk,acm
else
	setprop sys.usb.config none
	setprop sys.usb.config rndis,mass_storage,bulk,acm,adb
fi
