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
E_SET_VDE_R=16      # err of set video digital effect

aging_dir=/data/dji/amt/aging_test/
resp_file=/data/dji/amt/mb_ctrl_resp
cs_aging_log=/data/dji/amt/aging_test/wm232_cs_aging.txt
check_log_file=/data/dji/amt/aging_test/sd_check.txt
check_speed_file=/storage/sdcard0/check_sd

format=0
duration=300
storage_path=0
res_fps_code=0
resolution_width=10
fps=3
video_digital_effect=0
vid_codec_type=0

send_cnt=0
ack_ret=0

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

set_res_fps() {
    case $resolution_width in
        3840)
            if [ $fps -eq 24 ]; then
                cs_send_msg_n 0x18 5 0000000110
            elif [ $fps -eq 25 ]; then
                cs_send_msg_n 0x18 5 0000000210
            elif [ $fps -eq 30 ]; then
                cs_send_msg_n 0x18 5 0000000310
            elif [ $fps -eq 48 ]; then
                cs_send_msg_n 0x18 5 0000000410
            elif [ $fps -eq 50 ]; then
                cs_send_msg_n 0x18 5 0000000510
            elif [ $fps -eq 60 ]; then
                cs_send_msg_n 0x18 5 0000000610
            else
                cs_exit $E_INPUT "Invalid fps"
            fi
            ;;
        2688)
            if [ $fps -eq 24 ]; then
                cs_send_msg_n 0x18 5 000000012d
            elif [ $fps -eq 25 ]; then
                cs_send_msg_n 0x18 5 000000022d
            elif [ $fps -eq 30 ]; then
                cs_send_msg_n 0x18 5 000000032d
            elif [ $fps -eq 48 ]; then
                cs_send_msg_n 0x18 5 000000042d
            elif [ $fps -eq 50 ]; then
                cs_send_msg_n 0x18 5 000000052d
            elif [ $fps -eq 60 ]; then
                cs_send_msg_n 0x18 5 000000062d
            else
                cs_exit $E_INPUT "Invalid fps"
            fi
            ;;
        1920)
            if [ $fps -eq 24 ]; then
                cs_send_msg_n 0x18 5 000000010a
            elif [ $fps -eq 25 ]; then
                cs_send_msg_n 0x18 5 000000020a
            elif [ $fps -eq 30 ]; then
                cs_send_msg_n 0x18 5 000000030a
            elif [ $fps -eq 48 ]; then
                cs_send_msg_n 0x18 5 000000040a
            elif [ $fps -eq 50 ]; then
                cs_send_msg_n 0x18 5 000000050a
            elif [ $fps -eq 60 ]; then
                cs_send_msg_n 0x18 5 000000060a
            elif [ $fps -eq 120 ]; then
                cs_send_msg_n 0x18 5 000000070a
            elif [ $fps -eq 240 ]; then
                cs_send_msg_n 0x18 5 000000080a
            else
                cs_exit $E_INPUT "Invalid fps"
            fi
            ;;
        *) cs_exit $E_INPUT "Invalid resolution"
            ;;
    esac
}

camera_service_aging() {
  #select storage path
  if [ $storage_path -eq 0 ]; then
    #storage sdcard
    cs_send_msg_n 0xda 8 0100000200000001
    if [ $ack_ret -ne 0 ]; then
      cs_exit $E_SET_WM_R "CS_AGING: set sdcard storage path err:$ack_ret, send_cnt:$send_cnt"
    fi
    echo "sdcard"
  else
    #storage camera
    cs_send_msg_n 0xda 8 0001000200000001
    if [ $ack_ret -ne 0 ]; then
      cs_exit $E_SET_WM_R "CS_AGING: set camera storage path err:$ack_ret, send_cnt:$send_cnt"
    fi
    echo "emmc"
  fi

  # set mode profile to record
  cs_send_msg_n 0xe1 1 1
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_WM_R "CS_AGING: set record workmode err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 1

  # set video file format
  cs_send_msg_n 0x1c 1 $format

  # set video res and fps
  set_res_fps
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_VF_R "CS_AGING: set record video format err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 1

  # set video digital effect. 0:normal(8bit); 6:D-Cinelike(10bit)
  cs_send_msg_n 0x42 1 $video_digital_effect
  if [ $ack_ret -ne 0 ]; then
    cs_exit $E_SET_VDE_R "CS_AGING: set record video digital effect err:$ack_ret, send_cnt:$send_cnt"
  fi
  sleep 1

  # set video codec type 0:h264; 1:h265
  if [ $vid_codec_type -eq 0 ]; then
    cs_send_msg_n 0xab 1 0x00
  elif [ $vid_codec_type -eq 1 ]; then
    cs_send_msg_n 0xab 1 0x11
  else
    cs_exit $E_INPUT "Invalid codec type"
  fi
 
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

  #check recording status, record $duration seconds
  while [ $record_time -lt $duration ]; do
    cs_send_msg_0 70
    if [ $ack_ret -ne 0 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording ack_ret err:$ack_ret, send_cnt:$send_cnt"
    fi

    record_status=$(busybox od -An -t d -j 1 -N 1 $resp_file)
    let "record_status >>= 6"
    if [ $record_status -ne 2 ]; then
      cs_log "$E_CHECK_REC CS_AGING: check recording status err:$record_status ack_ret:$ack_ret"
    fi
    sleep 10
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

}

mkdir -p $aging_dir
date | busybox tee $cs_aging_log
ps | busybox grep -e .*dji.* | busybox tee -a $cs_aging_log

if [ $# -lt 3 ]; then
    cs_exit $E_INPUT "At least 3 arguments required"
fi

let resolution_width=$1
let fps=$2
let format=$3
let duration=300
let storage_path=0
let video_digital_effect=0
let vid_codec_type=0

if [ $# -eq 4 ]; then
    let duration=$4
fi

if [ $# -eq 5 ]; then
    let duration=$4
    let storage_path=$5
fi

if [ $# -eq 6 ]; then
    let duration=$4
    let storage_path=$5
    let video_digital_effect=$6
fi

if [ $# -eq 7 ]; then
    let duration=$4
    let storage_path=$5
    let video_digital_effect=$6
    let vid_codec_type=$7
fi

cs_send_msg_n 0x5c 1 0

cs_log "Record test is on the way, resolution is $resolution_width, fps is $fps, whole procee is gonna take $duration secs"

camera_service_aging

cs_exit 0 "Record test: SUCCESS!"
