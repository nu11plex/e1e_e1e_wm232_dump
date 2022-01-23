#!/system/bin/sh
E_SET_WM_C=1        # err of set capture workmode
E_SET_WM_R=2        # err of set record workmode
E_SET_WM_P=3        # err of set playback workmode
E_START_REC=4       # err of start record
E_CHECK_REC=5       # err of check recording status
E_START_PBV=6       # err of start video playback
E_STOP_PBV=7        # err of stop video playback
E_STOP_REC=8        # err of stop record
E_SINGLE_CAP=9      # err of single capture
E_CC_CAP=10         # err of burst capture
E_AEB_CAP=11        # err of AEB capture
E_FORMAT_SDCARD=12  # err of format sd card
E_GET_V_INFO=13     # err of get video DCF infor
E_INPUT=14          # err of input argument
E_SET_VF_R=15       # err of set record video format

CS_RECORD_STRESS=1
CS_RECORD_TIME=60
CS_VIDEO_PLAY_TIME=90
aging_dir=/data/dji/amt/aging_test/
resp_file=/data/dji/amt/mb_ctrl_resp
cs_aging_log=/data/dji/amt/aging_test/wm230_cs_aging.txt
check_log_file=/data/dji/amt/aging_test/sd_check.txt
check_speed_file=/storage/sdcard0/check_sd

del_test_file=1
storage_path=0
send_cnt=0
ack_ret=0
test_sd_speed()
{
    echo "test 320M"
    date >> $check_log_file
    busybox dd if=/dev/zero of=$check_speed_file bs=1M count=320 conv=fsync >> $check_log_file
    date >> $check_log_file
    busybox rm $check_speed_file -f
}
check_temp()
{
    echo "temprature : " >> $check_log_file
    cat /proc/driver/comip-thermal | busybox grep "last is" | busybox awk '{print $15}' >> $check_log_file
}
check_cpu()
{
    mpstat >> $check_log_file
    sleep 1
    mpstat >> $check_log_file
    mpstat -P 0 >> $check_log_file
    mpstat -P 1 >> $check_log_file
    mpstat -P 2 >> $check_log_file
    mpstat -P 3 >> $check_log_file
    mpstat -P 4 >> $check_log_file
    sleep 1
    mpstat -P 0 >> $check_log_file
    mpstat -P 1 >> $check_log_file
    mpstat -P 2 >> $check_log_file
    mpstat -P 3 >> $check_log_file
    mpstat -P 4 >> $check_log_file
}
check_mem()
{
    cat /proc/meminfo >> $check_log_file
    sleep 1
    cat /proc/meminfo >> $check_log_file
}

check_sdcard()
{
    busybox rm $check_log_file -f
    check_cpu
    check_mem
    test_sd_speed
}

cs_log() {
  echo $1 | busybox tee -a $cs_aging_log
}

cs_send_msg_0() {
  # cs_send_msg cmd
  if [ -e $resp_file ]; then
    busybox rm $resp_file
  fi
  let "send_cnt = 0"
  while [ $send_cnt -le 6 ]; do
    let "send_cnt += 1"
    dji_mb_ctrl -r -S test -R diag -g 1 -t 0 -s 2 -c $1 -a 40 -0
    if [ $? -ne 0 ]; then
      sleep 0.2
      continue
    fi

    sleep 1

    if [ -e $resp_file ]; then
      ack_ret=$(busybox od -An -t d -j 0 -N 1 $resp_file)
      if [ $ack_ret -ne 0 ]; then
        sleep 0.2
        continue
      else
        break
      fi
    else
      sleep 0.2
      continue
    fi

    break
  done

  if [ -e $resp_file ]; then
    ack_ret=$(busybox od -An -t d -j 0 -N 1 $resp_file)
  else
    ack_ret=-1
  fi
}

cs_send_msg_n() {
  # cs_send_msg cmd len data
  if [ -e $resp_file ]; then
    busybox rm $resp_file
  fi
  let "send_cnt = 0"
  while [ $send_cnt -le 6 ]; do
    let "send_cnt += 1"
    dji_mb_ctrl -r -S test -R diag -g 1 -t 0 -s 2 -c $1 -a 40 -$2 $3
    if [ $? -ne 0 ]; then
      sleep 0.2
      continue
    fi

    sleep 1

    if [ -e $resp_file ]; then
      ack_ret=$(busybox od -An -t d -j 0 -N 1 $resp_file)
      if [ $ack_ret -ne 0 ]; then
        sleep 0.2
        continue
      else
        break
      fi
    else
      sleep 0.2
      continue
    fi

    break
  done

  if [ -e $resp_file ]; then
    ack_ret=$(busybox od -An -t d -j 0 -N 1 $resp_file)
  else
    ack_ret=-1
  fi
}

cs_exit() {
  date | busybox tee -a $cs_aging_log
  ps | busybox grep -e .*dji.* | busybox tee -a $cs_aging_log

  #remove record and capture files
  if [ $del_test_file -eq 1 ]; then
    rm /storage/sdcard0/DCIM/100MEDIA/*.*
    rm /storage/sdcard0/MISC/THM/100/*.*
    rm /camera/DCIM/100MEDIA/*.*
    rm /camera/MISC/THM/100/*.*
  fi

  cs_send_msg_0 70
  if [ $ack_ret -ne 0 ]; then
    echo "can not get cam state, send_cnt:$send_cnt" | busybox tee -a $cs_aging_log
  else
    cs_status=$(busybox od -An -x $resp_file)
    echo $cs_status | busybox tee -a $cs_aging_log
  fi

  mount | busybox grep "/mnt/media_rw/" | busybox tee -a $cs_aging_log

  echo $2 | busybox tee -a $cs_aging_log
  cp $cs_aging_log /storage/sdcard0/
  exit $1
}

camera_service_aging() {

  #remove record and capture files
  if [ $del_test_file -eq 1 ]; then
    rm /storage/sdcard0/DCIM/100MEDIA/*.*
    rm /storage/sdcard0/MISC/THM/100/*.*
    rm /camera/DCIM/100MEDIA/*.*
    rm /camera/MISC/THM/100/*.*
  fi

  #select storage path
  if [ $storage_path -eq 0 ]; then
    #storage sdcard
    cs_send_msg_n 0xda 8 0100000200000001
    if [ $ack_ret -ne 0 ]; then
      cs_exit $E_SET_WM_R "CS_AGING: set sdcard storage path err:$ack_ret, send_cnt:$send_cnt"
    fi
  else
    #storage camera
    cs_send_msg_n 0xda 8 0001000200000001
    if [ $ack_ret -ne 0 ]; then
      cs_exit $E_SET_WM_R "CS_AGING: set camera storage path err:$ack_ret, send_cnt:$send_cnt"
    fi
  fi

  # set workmode to record
  cs_send_msg_n 10 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_R "CS_AGING: set record workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5

  # start to record 4k@30fps video
  # set video format :4k@30
  cs_send_msg_n 0x18 5 0000000310
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_VF_R "CS_AGING: set 4k 30fps record video format err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 2

  # start record
  cs_send_msg_n 2 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_START_REC "CS_AGING: start record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: start record success"

  # set the start record time
  start_rec_time=$(date +%s)
  current_time=$(date +%s)
  record_time=0
  let cs_rec_time=$CS_RECORD_TIME*$CS_RECORD_STRESS

  sleep 2

  # check recording status, record CS_RECORD_TIME seconds
  while [ $record_time -lt $cs_rec_time ]; do
    sleep 3
    cs_send_msg_0 70
    if [ $ack_ret -ne 0 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording ack_ret err:$ack_ret, send_cnt:$send_cnt"
    fi

    record_status=$(busybox od -An -t d -j 1 -N 1 $resp_file)
    let "record_status >>= 6"
    if [ $record_status -ne 2 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording status err:$record_status ack_ret:$ack_ret"
    fi

    current_time=$(date +%s)
    let "record_time = $current_time - $start_rec_time"
  done

  # stop record
  cs_send_msg_n 2 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_STOP_REC "CS_AGING: stop record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: stop record success"
  sleep 3

  # set workmode to cap
  cs_send_msg_n 10 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_C "CS_AGING: set capture workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5

  # single cap 1
  cs_send_msg_n 1 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SINGLE_CAP "CS_AGING: single capture err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: single cap success"
  sleep 2

  # set workmode to record
  cs_send_msg_n 10 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_R "CS_AGING: set record workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5
  # start to record 2.7k@60fps video
  # set video format :2.7k@60
  cs_send_msg_n 0x18 5 000000061f
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_VF_R "CS_AGING: set 2.7k 60fps record video format err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 2

  # start record
  cs_send_msg_n 2 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_START_REC "CS_AGING: start record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: start record success"

  # set the start record time
  start_rec_time=$(date +%s)
  current_time=$(date +%s)
  record_time=0
  let cs_rec_time=$CS_RECORD_TIME*$CS_RECORD_STRESS

  sleep 2

  # check recording status, record CS_RECORD_TIME seconds
  while [ $record_time -lt $cs_rec_time ]; do
    sleep 3
    cs_send_msg_0 70
    if [ $ack_ret -ne 0 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording ack_ret err:$ack_ret, send_cnt:$send_cnt"
    fi

    record_status=$(busybox od -An -t d -j 1 -N 1 $resp_file)
    let "record_status >>= 6"
    if [ $record_status -ne 2 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording status err:$record_status ack_ret:$ack_ret"
    fi

    current_time=$(date +%s)
    let "record_time = $current_time - $start_rec_time"
  done

  # stop record
  cs_send_msg_n 2 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_STOP_REC "CS_AGING: stop record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: stop record success"
  sleep 3

  # set workmode to cap
  cs_send_msg_n 10 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_C "CS_AGING: set capture workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5

  # single cap 1
  cs_send_msg_n 1 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SINGLE_CAP "CS_AGING: single capture err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: single cap success"
  sleep 2

  # set workmode to record
  cs_send_msg_n 10 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_R "CS_AGING: set record workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5
  # start to record 1080p@120fps video
  # set video format :1080p@120
  cs_send_msg_n 0x18 5 000000070a
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_VF_R "CS_AGING: set 1080p 120fps record video format err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 2

  # start record
  cs_send_msg_n 2 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_START_REC "CS_AGING: start record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: start record success"

  # set the start record time
  start_rec_time=$(date +%s)
  current_time=$(date +%s)
  record_time=0
  let cs_rec_time=$CS_RECORD_TIME*$CS_RECORD_STRESS

  sleep 2

  # check recording status, record CS_RECORD_TIME seconds
  while [ $record_time -lt $cs_rec_time ]; do
    sleep 3
    cs_send_msg_0 70
    if [ $ack_ret -ne 0 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording ack_ret err:$ack_ret, send_cnt:$send_cnt"
      continue
    fi

    record_status=$(busybox od -An -t d -j 1 -N 1 $resp_file)
    let "record_status >>= 6"
    if [ $record_status -ne 2 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording status err:$record_status ack_ret:$ack_ret"
    fi

    current_time=$(date +%s)
    let "record_time = $current_time - $start_rec_time"
  done

  # stop record
  cs_send_msg_n 2 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_STOP_REC "CS_AGING: stop record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: stop record success"
  sleep 3

  # set workmode to cap
  cs_send_msg_n 10 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_C "CS_AGING: set capture workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5

  # single cap 1
  cs_send_msg_n 1 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SINGLE_CAP "CS_AGING: single capture err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: single cap success"
  sleep 2

  # set workmode to record
  cs_send_msg_n 10 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_R "CS_AGING: set record workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5
  # start to record 720p@60fps video
  # set video format : 720p@60
  cs_send_msg_n 0x18 5 0000000604
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_VF_R "CS_AGING: set 720p 60fps record video format err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 2

  # start record
  cs_send_msg_n 2 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_START_REC "CS_AGING: start record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: start record success"

  # set the start record time
  start_rec_time=$(date +%s)
  current_time=$(date +%s)
  record_time=0
  let cs_rec_time=$CS_RECORD_TIME*$CS_RECORD_STRESS

  sleep 2

  # check recording status, record CS_RECORD_TIME seconds
  while [ $record_time -lt $cs_rec_time ]; do
    sleep 3
    cs_send_msg_0 70
    if [ $ack_ret -ne 0 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording ack_ret err:$ack_ret, send_cnt:$send_cnt"
      continue
    fi

    record_status=$(busybox od -An -t d -j 1 -N 1 $resp_file)
    let "record_status >>= 6"
    if [ $record_status -ne 2 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording status err:$record_status ack_ret:$ack_ret"
    fi

    current_time=$(date +%s)
    let "record_time = $current_time - $start_rec_time"
  done

  # stop record
  cs_send_msg_n 2 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_STOP_REC "CS_AGING: stop record err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: stop record success"
  sleep 3

  # set workmode to cap
  cs_send_msg_n 10 1 0
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_C "CS_AGING: set capture workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 5

  # single cap 1
  cs_send_msg_n 1 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SINGLE_CAP "CS_AGING: single capture err:$ack_ret, send_cnt:$send_cnt"
  fi
  cs_log "CS_AGING: single cap success"
  sleep 2

}

aging_cnt=1
mkdir -p $aging_dir
date | busybox tee $cs_aging_log
ps | busybox grep -e .*dji.* | busybox tee -a $cs_aging_log
if [ $# -eq 1 ]; then
  if [ $1 -lt 400 ]; then
    cs_exit $E_INPUT "camera aging time should at least 400 s, input time is:$1 s"
  fi
  let "aging_cnt = $1 / 400"
fi

#storage_path: 0=SDCARD, 1=EMMC
if [ $# -eq 2 ]; then
  if [ $1 -lt 400 ]; then
    cs_exit $E_INPUT "camera aging time should at least 400 s, input time is:$1 s"
  fi
  let "aging_cnt = $1 / 400"
  let "storage_path = $2"
fi

if [ $# -eq 3 ]; then
  if [ $1 -lt 400 ]; then
    cs_exit $E_INPUT "camera aging time should at least 400 s, input time is:$1 s"
  fi
  let "aging_cnt = $1 / 400"
  let "storage_path = $2"
  let "del_test_file = $3"
fi


#set reset fileindex mode in DCF
cs_send_msg_n 0x5c 1 0

cs_log "*****CS_AGING: need to aging for $aging_cnt : $storage_path rounds*****"
while [ $aging_cnt -gt 0 ]; do
  camera_service_aging
  cs_log "*****CS_AGING: SUCCESS for 5 minutes*****"
  #sleep 10
  let "aging_cnt -= 1"
done

cs_exit 0 "CS_AGING: SUCCESS for $1 seconds!"
