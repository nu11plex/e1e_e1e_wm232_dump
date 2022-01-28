json_name=/system/etc/clear_file_list.json
temp_file=/data/clear_temp_file

myecho()
{
    echo "[$(date)] $*"
}

########################################## 1. clear log fucntion ############################################
do_clear_file()
{
    local temp=$1
    local file=`echo `${temp%*/}``

    if [ -d $file ]; then
        delete_file=$file/*
    else
        delete_file=$file
    fi

    myecho "do_clear_file $delete_file"
    rm -rf $delete_file
    return 0
}

do_clear_module()
{
    local name=$1
    myecho "start clear module=$name"
    cat $json_name|jq .log|jq ".$name" |jq -r .[] >> $temp_file
    while read -r line
    do
        do_clear_file $line
    done < $temp_file
    sync
}

do_clear_content()
{
    local name=$1
    myecho "start clear content=$name"
    cat $json_name|jq .log |jq "map(.[])" |jq -r .[] |grep "^/$name/" >> $temp_file
    while read -r line
    do
        do_clear_file $line
    done < $temp_file
    sync
}

do_clear_all()
{
    myecho "start clear all"
    cat $json_name|jq .log |jq "map(.[])" |jq -r .[] >> $temp_file
    while read -r line
    do
        do_clear_file $line
    done < $temp_file
    sync
}

###################################################### 2. check log fucntion ###################################################
check_file_exist()
{
    local temp=$1
    local file=`echo `${temp%*/}``

    if [ -e $file ]; then
        if [ -d $file ]; then
            if [ "`ls -a $file`"x != ""x ]; then
                return 11
            fi
        fi
        return 0
    else
        return 0
    fi
}

do_check_module()
{
    local name=$1

    myecho "start check module=$name"
    if [ ! -e $temp_file ]; then
        cat $json_name|jq .log |jq ".$name" |jq -r .[] >> $temp_file
    fi

    while read -r line
    do
        check_file_exist $line
        if [ $? != 0 ]; then
            myecho "check $line faild"
            return 11
        fi
    done < $temp_file

    return 0
}

do_check_content()
{
    local name=$1
    local n=0
    myecho "start clear content=$name"
    if [ ! -e $temp_file ]; then
        cat $json_name|jq .log |jq "map(.[])" |jq -r .[] |grep "^/$name/" >> $temp_file
    fi

    while read -r line
    do
        check_file_exist $line
        if [ $? != 0 ]; then
            myecho "check $line faild"
            return 11
        fi
    done < $temp_file

    return 0
}

do_check_all()
{
    local n=0
    myecho "start clear all"
    if [ ! -e $temp_file ]; then
        cat $json_name|jq .log |jq "map(.[])" |jq -r .[] >> $temp_file
    fi

    while read -r line
    do
        check_file_exist $line
        if [ $? != 0 ]; then
            myecho "check $line faild"
            return 11
        fi
    done < $temp_file

    return 0
}

###################################################### 3. parse parm and do clean action ###################################################
parm=$1
rm -rf $temp_file

if [ $# -ne 1 ]; then
    myecho "invalid parameters($@)!\n"
    myecho "Please input parm as: all/blackbox/data/camera/system/flyctrl/gimbal/perception/navigtaion/ofdm/autotest...\n"
    exit 1
fi

## we need to put the sdcard adn media attach to board
setprop persist.dji.storage.exportable 1
sync
sleep 1
test_hal_storage -c "0 volume detach_pc"

if [ $parm = "all" ]; then
    do_clear_all
    do_check_all
elif [ $parm = "blackbox" ]; then
    do_clear_content blackbox
    do_check_content blackbox
elif [ $parm = "data" ]; then
    do_clear_content data
    do_check_content data
else
    do_clear_module $parm
    do_check_module $parm
fi

if [ $? != 0 ]; then
    myecho "clear $parm _faild_."
    rm -rf $temp_file
    exit 11
else
    myecho "clear $parm _success_."
    rm -rf $temp_file
    exit 0
fi