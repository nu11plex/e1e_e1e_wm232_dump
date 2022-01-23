#!/system/bin/sh

function show_help {
    echo "========================================================="
    echo "Usage:"
    echo "$0 <raw file> -res_id 4x3 -sensor_name IMX586 -i -f -awb"
    echo '   <raw file>: the file path of the raw file. <raw file>.txt file should be existing as well.'
    echo '   -res_id: a string used to choose stream group, \"4x3\" for example. This param is mandatory.'
    echo '   -sensor_name: choose the sensor you want f2f to imitate, \"IMX586\" for example. This param is mandatory.'
    echo '   -no_sn: this param is optional. If you do not want factory calibration data to take effect, you must assign this param.
                 Then, module_sn in txt file will be ignored.'
    echo '   -i: interactive mode.'
    echo '   -f: force the log to console.'
    echo '   -awb: using awb instead of hardcoded gains in raw info file.'
    echo ''
    echo "Example: $0 /data/my.raw -res_id 4x3"
    echo "========================================================"
}

function check_raw_file {
    if [ -z "$1" ]; then
        echo 'raw file is not specified.'
        show_help
        exit 1
    fi

    if [ ! -f $1 ]; then
        echo "raw file:$1 doesn't exist."
        exit 1
    fi
}

function check_raw_info_file {
    if [ ! -f $1 ]; then
        echo "raw info file:$1 doesn't exist."
        exit 1
    fi
}

function check_res_id {
    if [ -z "$1" ]; then
        echo 'res_id is not specified.'
        show_help
        exit 1
    fi
}

function check_sensor_name {
    if [ -z "$1" ]; then
        echo 'sensor_name is not specified.'
        show_help
        exit 1
    fi
}

function check_module_sn {
    if [ -z "$1" ]; then
        echo 'module_sn is not specified.'
        show_help
        exit 1
    fi
}

function check_module_version {
    if [ -z "$1" ]; then
        echo 'module_version is not specified.'
        show_help
        exit 1
    fi
}

function check_width {
    if [ -z "$1" ]; then
        echo 'Width is not specified.'
        show_help
        exit 1
    fi
}

function check_height {
    if [ -z "$1" ]; then
        echo 'height is not specified.'
        show_help
        exit 1
    fi
}

function check_hdr_eanble {
    if [ -z "$1" ]; then
        echo 'is_sensor_hdr is not specified.'
        show_help
        exit 1
    fi
}

function check_cfa_pattern {
   if [ -z "$1" ]; then
        echo 'cfa_pattern is not specified.'
        show_help
        exit 1
   fi
   case "$1" in
        "rggb") ;;
        "grbg") ;;
        "gbrg") ;;
        "bggr") ;;
        *)
          echo "Invalid cfa_pattern:$1"
          show_help
          exit 1
	;;
   esac
}

function check_bitdepth {
    if [ -z "$1" ]; then
       echo 'bit_depth is not specified.'
       show_help
       exit 1
    fi
    case "$1" in
       "10") ;;
       "12") ;;
       *)
         echo "Invalid bit_depth is specified:$1."
         show_help
         exit 1
	;;
   esac
}

RAW_FILE=$1
RAW_FILE_CAP=$2
RES_ID=
SENSOR_NAME=
MODULE_SN=
MODULE_VERSION=
WIDTH=
HEIGHT=
CFA_PATTERN=
IS_SENSOR_HDR=
BITDEPTH=
WB_GAINS=
EXPO_INFO=
OTHER_FLAGS=
USING_AWB=
NO_SN=0
EV_BIAS=
IRIDIX=
CTEMP=

if [[ -f $RAW_FILE_CAP ]]; then
shift
fi

shift

if [ "$1" == "-res_id" ]; then
    shift
    case "$1" in
        "-sensor_name")
        echo "value for -res_id is not specified"
        show_help
        exit 1
        ;;
        "-i")
        echo "value for -res_id is not specified"
        show_help
        exit 1
        ;;
        "-f")
        echo "value for -res_id is not specified"
        show_help
        exit 1
        ;;
        "-awb")
        echo "value for -res_id is not specified"
        show_help
        exit 1
        ;;
        "-h")
        echo "value for -res_id is not specified"
        show_help
        exit 1
        ;;
        *)
        ;;
    esac
    RES_ID=$1
    shift
fi

if [ "$1" == "-sensor_name" ]; then
    shift
    case "$1" in
        "-res_id")
        echo "value for -sensor_name is not specified"
        show_help
        exit 1
        ;;
        "-i")
        echo "value for -sensor_name is not specified"
        show_help
        exit 1
        ;;
        "-f")
        echo "value for -sensor_name is not specified"
        show_help
        exit 1
        ;;
        "-awb")
        echo "value for -sensor_name is not specified"
        show_help
        exit 1
        ;;
        "-h")
        echo "value for -sensor_name is not specified"
        show_help
        exit 1
        ;;
        *)
        ;;
    esac
    SENSOR_NAME=$1
    shift
fi

until [ $# -eq 0 ]
do
case "$1" in
    "-i")
    OTHER_FLAGS="$OTHER_FLAGS -i"
    ;;
    "-f")
    OTHER_FLAGS="$OTHER_FLAGS -f"
    ;;
    "-awb")
    USING_AWB=1
    ;;
    "-no_sn")
    NO_SN=1
    ;;
    "-h")
    show_help
    exit 0
    ;;
    *)
    echo "Invalid parameter:$1"
    show_help
    exit 1
    ;;
esac
shift
done

check_raw_file $RAW_FILE
check_raw_info_file $RAW_FILE.txt
check_res_id $RES_ID
check_sensor_name $SENSOR_NAME


if [[ -z "$RAW_FILE_CAP" || ! -f $RAW_FILE_CAP ]]; then
    echo "source raw file for capture not exist, use $RAW_FILE as capture source"
    RAW_FILE_CAP=$RAW_FILE
fi

while read LINE
do
   if [[ $LINE == *"res_liveview:"* ]]; then
       RES=${LINE#*res_liveview:*}
       TMP=( $RES )
       WIDTH=${TMP[0]}
       WIDTH=${WIDTH//[[:blank:]]/}

       HEIGHT=${TMP[1]}
       HEIGHT=${HEIGHT//[[:blank:]]/}
   fi

   if [[ $LINE == *"res_capture:"* ]]; then
       RES=${LINE#*res_capture:*}
       TMP=( $RES )
       WIDTH_CAP=${TMP[0]}
       WIDTH_CAP=${WIDTH_CAP//[[:blank:]]/}

       HEIGHT_CAP=${TMP[1]}
       HEIGHT_CAP=${HEIGHT_CAP//[[:blank:]]/}
   fi


   if [[ $LINE == *"bitdepth:"* ]]; then
       BITDEPTH=${LINE#*bitdepth:*}
       BITDEPTH=${BITDEPTH//[[:blank:]]/}
   fi

   if [[ $LINE == *"is_sensor_hdr:"* ]]; then
       IS_SENSOR_HDR=${LINE#*is_sensor_hdr:*}
       IS_SENSOR_HDR=${IS_SENSOR_HDR//[[:blank:]]/}
   fi

   if [[ $LINE == *"module_sn:"* ]]; then
       MODULE_SN=${LINE#*module_sn:*}
       MODULE_SN=${MODULE_SN//[[:blank:]]/}
   fi

   if [[ $LINE == *"module_ver:"* ]]; then
       MODULE_VERSION=${LINE#*module_ver:*}
       MODULE_VERSION=${MODULE_VERSION//[[:blank:]]/}
   fi

   if [[ $LINE == *"cfa:"* ]]; then
       CFA_PATTERN=${LINE#*cfa:*}
       CFA_PATTERN=${CFA_PATTERN//[[:blank:]]/}
   fi

   if [[ $LINE == *"wb_gains:"* ]]; then
       WB_GAINS=${LINE#*wb_gains:*}
   fi

   if [[ $LINE == *"expo_info:"* ]]; then
       EXPO_INFO=${LINE#*expo_info:*}
   fi

   if [[ $LINE == *"ev_bias:"* ]]; then
       EV_BIAS=${LINE#*ev_bias:*}
   fi

   if [[ $LINE == *"iridix:"* ]]; then
       IRIDIX=${LINE#*iridix:*}
   fi

   if [[ $LINE == *"ctemp:"* ]]; then
       CTEMP=${LINE#*ctemp:*}
   fi
done < $RAW_FILE.txt

check_width $WIDTH
check_height $HEIGHT
check_width $WIDTH_CAP
check_height $HEIGHT_CAP
check_cfa_pattern $CFA_PATTERN
check_bitdepth $BITDEPTH
check_hdr_eanble $IS_SENSOR_HDR

if [ $USING_AWB ]; then
    WB_GAINS=
fi

echo "NO_SN=$NO_SN"

if [ $NO_SN -eq 0 ]; then
    check_module_sn $MODULE_SN
else
    #The reason we need string "NO_SN" is that value of module_param_string would not change if you set it to "".
    MODULE_SN=NO_SN
    #factory calibration data will not take effect
fi

echo "MODULE_SN=$MODULE_SN"

echo "CTEMP=$CTEMP"

#module_version is always mandatory.
check_module_version $MODULE_VERSION

mkdir -p /data/dcam

ln -s -f `readlink -f $RAW_FILE`        /data/dcam/vsensor_source_liveview.raw
ln -s -f `readlink -f $RAW_FILE_CAP`    /data/dcam/vsensor_source_capture.raw
if [ $? -ne 0 ]; then
    echo 'creating vsensor_source_*.raw failed.'
    exit 1
fi

echo -n "$SENSOR_NAME" > /sys/module/rcam_dji/parameters/vsensor_name
cat /sys/module/rcam_dji/parameters/vsensor_name

echo -n "$MODULE_SN" > /sys/module/rcam_dji/parameters/fake_eep_module_sn
cat /sys/module/rcam_dji/parameters/fake_eep_module_sn

echo -n "$MODULE_VERSION" > /sys/module/rcam_dji/parameters/fake_eep_module_version
cat /sys/module/rcam_dji/parameters/fake_eep_module_version

sleep 1

export DCAM_VSENSOR="w=$WIDTH;h=$HEIGHT;w_c=$WIDTH_CAP;h_c=$HEIGHT_CAP;o=$CFA_PATTERN;b=$BITDEPTH;is_sensor_hdr=$IS_SENSOR_HDR;res_id=$RES_ID;sensor_name=$SENSOR_NAME;no_sn=$NO_SN;module_sn=$MODULE_SN;ev_bias=$EV_BIAS;iridix=$IRIDIX;ctemp=$CTEMP;";
export DCAM_EXPO_INFO="$EXPO_INFO";
export DCAM_WB_GAINS="$WB_GAINS";
dji_cht -c still_f2f -d 4 $OTHER_FLAGS

