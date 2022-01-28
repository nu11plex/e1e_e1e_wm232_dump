#!/system/bin/sh

CSI_HOST_STATUS_OK="0x00000000"
MIPI_RX_STATUS_OK="0x00000100"
FRAME_NUM_FAIL="0x00000000"
FRAME_INTERVAL_FAIL="0x0000"
result=0

echo "reset 0xfd0071cc: 0x1ff -> 0xfd0071d8"
adb shell busybox devmem 0xfd0071d8 32 0x1ff
sleep 0.5

echo "set e1e mipi tx output enable"
dji_mb_ctrl -R diag -g 1 -t 0 -s 8 -c 0x41 -1 1

echo "check e1e mipi tx status..."
test_index=0
last_val=`busybox devmem 0xFD401110 32`
echo "mipi tx status last_val = $last_val"
while [ test_index -le 6000 ]; do
  let "test_index += 1"
  ret_val=`busybox devmem 0xFD401110 32`
  if [ $last_val != $ret_val ]; then
    echo "mipi tx status ret = $ret_val"
    echo "check e1e mipi tx ouput success..."
    break
  fi
  usleep 10000
done

if [ test_index -gt 60 ]; then
  echo "check e1e mipi tx ouput fail..."
  result=1
else
  result=0
fi

echo "checking mipi csi host status..."
csi_host_val=`adb shell busybox devmem 0xfd00500c | cut -c 1-10`
if [ "$csi_host_val" != $CSI_HOST_STATUS_OK ]; then
    echo "csi host 0xfd00500c status __fail, $csi_host_val..."
    result=1
else
    echo "check csi host success..."
fi

echo "checking encoded frame number..."
frame_num=`adb shell busybox devmem 0xfffc1100 | cut -c 1-10`
if [ "$frame_num" != $FRAME_NUM_FAIL ]; then
    echo "check frame number success..."
else
    echo "encoded number 0xfffc1100 __fail, $frame_num..."
    result=1
fi

echo "checking frame interval..."
frame_intv=`adb shell busybox devmem 0xfffc10ea 16 | cut -c 1-6`
if [ "$frame_intv" != $FRAME_INTERVAL_FAIL ]; then
    echo "check frame interval success..."
else
    echo "check frame interval 0xfffc10ea __fail, $frame_intv..."
    result=1
fi

echo "checking mipi rx interface status..."
rx_val=`adb shell busybox devmem 0xfd0071cc | cut -c 1-10`
if [ "$rx_val" != $MIPI_RX_STATUS_OK ]; then
    echo "rx interface 0xfd0071cc status __fail, $rx_val..."
    result=1
else
    echo "check rx interface success..."
fi

if [ $result -ne 0 ]; then
    echo "test_mipi_link.sh __fail..."
else
    echo "test_mipi_link.sh success..."
fi

exit $result


