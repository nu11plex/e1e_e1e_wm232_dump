#!/system/bin/sh

echo "wm232 core board test start!"
setprop dji.camera_service 0
sleep 2

echo "remove local DCIM directory"
rm -rf /data/local/DCIM
rm -rf /data/local/MISC

echo "begin recording file"
dji_cht -c factory_core_board_recoding_h264 -g local -f
if [ $? -ne 0 ]; then
  echo "++++++++++++++++++++++++++"
  echo "dji_cht run fail"
  echo "test NG!"
  echo "++++++++++++++++++++++++++"
  exit 1
else
  if [ -e /data/local/DCIM/100MEDIA/DJI_0001.MP4 ]; then
    echo "++++++++++++++++++++++++++"
    echo "recoding file success"
    echo "test passed!"
    echo "++++++++++++++++++++++++++"
    rm -rf /data/local/DCIM
    rm -rf /data/local/MISC
  else
    echo "++++++++++++++++++++++++++"
    echo "recoding file fail"
    echo "test NG!"
    echo "++++++++++++++++++++++++++"
    exit 1
  fi
fi

exit 0
