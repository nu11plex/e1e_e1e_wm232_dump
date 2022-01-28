flag_file_path=/data/dji/cfg/
flag_file=$flag_file_path/clean_factory_log_en

if [ $# -ne 1 -a $# -ne 2 ]; then
    echo "invalid parameters($@)!"
    echo "Please input parm as: [clean_magic_flag] all/blackbox/data/camera/system/flyctrl/gimbal/perception/navigtaion/ofdm/autotest...\n"
    exit 1
fi

if [ ! -d $flag_file_path ]; then
    mkdir -p $flag_file_path
fi

if [ $# -eq 1 ]; then
    echo $1 > $flag_file
    echo "write $1 to flag file $flag_file"
else
    flag_file="$flag_file_path/$1"
    echo $2 > $flag_file
    echo "write $2 to flag file $flag_file"
fi

sync

exit 0
