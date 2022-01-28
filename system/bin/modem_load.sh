#!/system/bin/sh

usbfile="/sys/kernel/debug/usb/devices"

bootrom=`grep ProdID=0040 $usbfile`
bootloader=`grep ProdID=d00d $usbfile`
brexist=`echo $bootrom | wc -w`
blexist=`echo $bootloader | wc -w`


if [ $brexist -gt 0 ] ; then
 echo ------$bootrom exist info $brexist
 brload /vendor/modem_firmware/pigeon/bootarea.img

 sleep 2

 # For flexibility, We need an input pubkey to verify the signed firmware image header.
 # Now we use bootarea instead of a separate "pubkey.bin", to reduce maintenance costs.

 fastboot flash modem-pub_key /vendor/modem_firmware/pigeon/bootarea.img

 fastboot flash modem-share_info /vendor/modem_firmware/pigeon/info.img

 fastboot flash modem-rta7_nvram /cali/sdr/pigeon/nvram/cp_nvram.bin

 fastboot flash modem-rf_nvram /cali/sdr/pigeon/nvram/rf_nvram.bin

 fastboot flash modem-amt /cali/sdr/pigeon/amt.bin

 fastboot flash modem-dsp_1643 /vendor/modem_firmware/pigeon/pigeon_x1643.bin

 fastboot flash modem-dsp_45000 /vendor/modem_firmware/pigeon/pigeon_xc4500_0.bin

 fastboot flash modem-dsp_45001 /vendor/modem_firmware/pigeon/pigeon_xc4500_1.bin

 fastboot flash modem-cp /vendor/modem_firmware/pigeon/pigeon_arm.bin
fi

done;
