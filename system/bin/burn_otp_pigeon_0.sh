timeout=5000

/tmp/encrypt/fastboot flash cmpu_otp /tmp/encrypt/otp.sec
[ $? -ne 0 ] && echo "cmpu otp failed" && exit 4

/tmp/encrypt/fastboot reboot
[ $? -ne 0 ] && echo "reboot failed" && exit 5

exit 0