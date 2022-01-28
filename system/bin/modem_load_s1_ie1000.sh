#!/system/bin/sh

usbfile="/sys/kernel/debug/usb/devices"
sleep 2
bootrom=`grep ProdID=0040 $usbfile`
bootloader=`grep ProdID=d00d $usbfile`
brexist=`echo $bootrom | wc -w`
blexist=`echo $bootloader | wc -w`

if [ $brexist -gt 0 ] ; then
 echo ------$bootrom exist info $brexist
 brload /vendor/modem_firmware/sparrow/IE1000_RF/enc/bootarea.img
 fastboot flash modem-pub_key      /vendor/modem_firmware/sparrow/IE1000_RF/enc/bootarea.img
 fastboot flash modem-s1-rf-nvram  /vendor/modem_firmware/sparrow/IE1000_RF/rf_nvram.bin
 fastboot flash modem-s1-amt       /cali/sdr/sparrow/IE1000_RF/nvram/amt.bin
 fastboot flash modem-s1-nvram     /cali/sdr/sparrow/IE1000_RF/nvram/cp_nvram.bin
 fastboot flash modem-s1-pwr       /vendor/modem_firmware/sparrow/IE1000_RF/pwr.bin
 fastboot flash modem-s1-ap        /vendor/modem_firmware/sparrow/IE1000_RF/enc/ap.img
 fastboot flash modem-s1-cp        /vendor/modem_firmware/sparrow/IE1000_RF/enc/cp.img
 echo "fastboot end"
fi

