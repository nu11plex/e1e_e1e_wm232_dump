#!/system/bin/sh

bootrom_pid=0040
bootloader_pid=d00d
busnum=3
portnum=1
timeout=2000
path="/sys/bus/usb/devices/$busnum-1.$portnum"

while true;
do

if [ -d $path ] ; then
	pid=$(cat $path/idProduct)

	if [ $pid -eq $bootrom_pid ] ; then
		echo ------detect pigeon bootrom $bootrom_pid
		brload /vendor/modem_firmware/pigeon/bootarea.img -B $busnum -P $portnum
	fi

	if [ $pid -eq $bootloader_pid ] ; then
		echo ------detect pigeon bootloader $bootloader_pid

		# For flexibility, We need an input pubkey to verify the signed firmware image header.
		# Now we use bootarea instead of a separate "pubkey.bin", to reduce maintenance costs.

		fastboot flash modem-pub_key /vendor/modem_firmware/pigeon/bootarea.img -B $busnum -P $portnum -T $timeout

		fastboot flash modem-share_info /vendor/modem_firmware/pigeon/info.img -B $busnum -P $portnum -T $timeout

		fastboot flash modem-rta7_nvram /cali/sdr/nvram/rta7_nvram_r2.bin -B $busnum -P $portnum -T $timeout

		fastboot flash modem-rf_nvram /cali/sdr/nvram/rf_nvram.bin -B $busnum -P $portnum -T $timeout

		fastboot flash modem-amt /cali/sdr/nvram/amt.bin -B $busnum -P $portnum -T $timeout

		fastboot flash modem-package /vendor/modem_firmware/pigeon/cp.img -B $busnum -P $portnum -T $timeout

		fastboot flash modem-normal /vendor/modem_firmware/pigeon/normal.img -B $busnum -P $portnum -T $timeout
		sleep 5
	fi
fi

sleep 2;

done;
