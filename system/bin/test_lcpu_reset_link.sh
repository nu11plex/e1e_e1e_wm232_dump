#!/system/bin/sh -x

logcat -c
echo "3 0 0" > /sys/devices/platform/fd100000.rcam/programmable_lens
sleep 1
logcat | grep "Get total info failed" > Lens_reset_check.log &
sleep 0.5
if [ -s Lens_reset_check.log ]; then
    echo "OK!"
    rm Lens_reset_check.log
    exit 0
else
    echo "NG!"
    rm Lens_reset_check.log
    exit 1
fi
