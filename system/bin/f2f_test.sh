#!/system/bin/sh

test_index=1
test_pass=1

TEST_DIR=/camera/f2f_test
COMPARE_STR1=CHT_RLT:still_f2f:\ PASSED
TEST_RESULT=${TEST_DIR}/test_result.log

echo "param count = $#"

if [ $# -ne 11 ]; then
  echo "wrong param count."
  echo "usage: f2f_test.sh test_name sensor_name liveview_raw capture_raw raw_txt res_id test_sequence no_sn have_cali_data quit_immediately test_rounds"
  exit 1
fi

test_name=$1
sensor_name=$2
liveview_raw=$3
capture_raw=$4
raw_txt=$5
res_id=$6
test_sequence=$7
is_no_sn=$8
if [ $is_no_sn -eq 0 ]; then
  no_sn=
else
  no_sn="-no_sn"
fi
have_cali_data=$9
quit_immediately=${10}
test_rounds=${11}

echo "test_name = $test_name"
echo "sensor_name = $sensor_name"
echo "liveview_raw=$liveview_raw"
echo "capture_raw=$capture_raw"
echo "raw_txt=$raw_txt"
echo "res_id=$res_id"
echo "test_sequence=$test_sequence"
echo "is_no_sn=$is_no_sn"
echo "no_sn=$no_sn"
echo "have_cali_data=$have_cali_data"
echo "quit_immediately=$quit_immediately"
echo "test_rounds=$test_rounds"

setprop dji.camera_service 0
test_hal_storage -c "0 volume detach_pc"

sleep 5

mkdir -p ${TEST_DIR}

while [ test_index -le $test_rounds ]; do
  echo "*****${test_name} round $test_index start*****"

  ps | grep dji

  cht_pid=$(ps |grep -w 'dji_cht'|grep -v grep|cut -c 9-15)
  if ["" == "$cht_pid"]; then
    echo "cht_pid = NULL, do nothing"
  else
    echo "cht_pid = $cht_pid, kill it"
    #kill -6 twice, to kill the unstopped dji_cht process if any, and collect tombstones.
    kill -6 $cht_pid
    sleep 1
    kill -6 $cht_pid
    echo "sleep 5"
    sleep 5
  fi

  echo "remove image and video files"

  raw_org_txt="${liveview_raw}.txt"

  echo "cp $raw_txt $raw_org_txt"
  cp $raw_txt $raw_org_txt

  DJI_CHT_LOG="${TEST_DIR}/${test_name}_${is_no_sn}_${have_cali_data}_${quit_immediately}_${test_index}.txt"
  echo "dji_cam_f2f.sh > $DJI_CHT_LOG"
  if [ $quit_immediately -eq 0 ]; then
    echo -ne $test_sequence | timeout 300 dji_cam_f2f.sh $liveview_raw $capture_raw -res_id ${res_id} -sensor_name ${sensor_name} ${no_sn} -i -f | busybox tee -a $DJI_CHT_LOG
  else
    #quit
    echo -ne "q\n" | timeout 300 dji_cam_f2f.sh $liveview_raw $capture_raw -res_id ${res_id} -sensor_name ${sensor_name} ${no_sn} -i -f | busybox tee -a $DJI_CHT_LOG
  fi

  echo "+++++++++++++++++++++++++++++++++" | busybox tee -a $DJI_CHT_LOG
  CHECK_STR=$(busybox grep "$COMPARE_STR1" -rn $DJI_CHT_LOG)
  if [ -z "$CHECK_STR" ]; then
    echo "can not find \"$COMPARE_STR1\"" | busybox tee -a $DJI_CHT_LOG
    let "test_pass = 0"
    echo $test_name $is_no_sn $have_cali_data $quit_immediately $test_rounds: failed | busybox tee -a $DJI_CHT_LOG
    break
  else
    echo $test_name $is_no_sn $have_cali_data $quit_immediately $test_rounds: passed | busybox tee -a $DJI_CHT_LOG
  fi
  echo "+++++++++++++++++++++++++++++++++" | busybox tee -a $DJI_CHT_LOG

  echo "sleep 5"
  sleep 5
  let "test_index += 1"
done

if [ $test_pass -eq 0 ]; then
  echo $test_name $is_no_sn $have_cali_data $quit_immediately $test_rounds: failed | busybox tee -a $TEST_RESULT
else
  echo $test_name $is_no_sn $have_cali_data $quit_immediately $test_rounds: passed | busybox tee -a $TEST_RESULT
fi

