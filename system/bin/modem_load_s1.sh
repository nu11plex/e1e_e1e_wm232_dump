#!/system/bin/sh

usbfile="/sys/kernel/debug/usb/devices"

bootrom=`grep ProdID=0040 $usbfile`
bootloader=`grep ProdID=d00d $usbfile`
brexist=`echo $bootrom | wc -w`
blexist=`echo $bootloader | wc -w`

if [ $brexist -gt 0 ] ; then
 echo ------$bootrom exist info $brexist
 brload /vendor/modem_firmware/sparrow/bootarea.img
 sleep 2
 fastboot flash modem-s1-rf-nvram  /vendor/modem_firmware/sparrow/TX_RF/rf_nvram.bin
 fastboot flash modem-s1-amt       /cali/sdr/sparrow/TX_RF/nvram/amt.bin
 fastboot flash modem-s1-nvram     /cali/sdr/sparrow/TX_RF/nvram/cp_nvram.bin
 fastboot flash modem-s1-pwr       /vendor/modem_firmware/sparrow/TX_RF/pwr.bin
 fastboot flash modem-s1-ap        /vendor/modem_firmware/sparrow/TX_RF/ap.bin
 fastboot flash modem-s1-cp        /vendor/modem_firmware/sparrow/TX_RF/cp.bin
 echo "fastboot end"
fi


done;
