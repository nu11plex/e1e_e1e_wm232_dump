json_name=/system/etc/clear_file_whitelist.json
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

do_clear_content()
{
    local name=$1
    myecho "start clear content=$name"
    # Check json format
    cat $json_name |jq "map(.[])"
    if [ $? -ne 0 ]; then
        myecho "json file format error, just return"
        return 1
    fi

    busybox ls "/$name" -1 | busybox awk '{print i$0}' i="/$name/" >> $temp_file
    while read -r line
    do
        is_exist=`cat $json_name |jq "map(.[])" | jq -r .[] | grep "^$line"`
        if [ $? -eq 0 -a "$is_exist"x != ""x ]; then
            myecho "found $is_exist from white list, skip it"
        else
            do_clear_file $line
        fi
    done < $temp_file

    sync
}

do_clear_all()
{
    myecho "start clear all"
    # Check json format
    cat $json_name |jq "map(.[])"
    if [ $? -ne 0 ]; then
        myecho "json file format error, just return"
        return 1
    fi

    busybox ls "/blackbox" -1 | busybox awk '{print i$0}' i="/blackbox/" >> $temp_file
    busybox ls "/data" -1 | busybox awk '{print i$0}' i="/data/" >> $temp_file
    while read -r line
    do
        is_exist=`cat $json_name |jq "map(.[])" | jq -r .[] | grep "^$line"`
        if [ $? -eq 0 -a "$is_exist"x != ""x ]; then
            myecho "found $is_exist from white list, skip it"
        else
            do_clear_file $line
        fi
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

do_check_content()
{
    local name=$1
    local n=0
    myecho "start clear content=$name"
    if [ ! -e $temp_file ]; then
        busybox ls "/$name" -1 | busybox awk '{print i$0}' i="/$name/" >> $temp_file
    fi

    while read -r line
    do
        is_exist=`cat $json_name |jq "map(.[])" | jq -r .[] | grep "^$line"`
        if [ $? -eq 0 -a "$is_exist"x != ""x ]; then
            myecho "found $is_exist from white list, skip it"
        else
            check_file_exist $line
            if [ $? != 0 ]; then
                myecho "check $line faild"
                return 11
            fi
        fi
    done < $temp_file

    return 0
}

do_check_all()
{
    local n=0
    myecho "start check all"
    if [ ! -e $temp_file ]; then
        busybox ls "/blackbox" -1 | busybox awk '{print i$0}' i="/blackbox/" >> $temp_file
        busybox ls "/data" -1 | busybox awk '{print i$0}' i="/data/" >> $temp_file
    fi

    while read -r line
    do
        is_exist=`cat $json_name |jq "map(.[])" | jq -r .[] | grep "^$line"`
        if [ $? -eq 0 -a "$is_exist"x != ""x ]; then
            myecho "found $is_exist from white list, skip it"
        else
            check_file_exist $line
            if [ $? != 0 ]; then
                myecho "check $line faild"
                return 11
            fi
        fi
    done < $temp_file

    return 0
}

exit_on_error()
{
    if [ $1 -ne 0 ]; then
        echo "clear data failed"
        exit 1
    fi
}

###################################################### 3. parse param and do clean action ###################################################
param=$1
rm -rf $temp_file

if [ $# -ne 1 ]; then
    myecho "invalid parameters($@)!\n"
    myecho "Please input param as: all/blackbox/data/camera/system/flyctrl/gimbal/perception/navigtaion/ofdm/autotest...\n"
    exit 1
fi

## we need to put the sdcard adn media attach to board
test_hal_storage -c "0 volume detach_pc"

if [ $param = "all" ]; then
    do_clear_all
    exit_on_error $?
    do_check_all
    ret=$?
elif [ $param = "blackbox" ]; then
    do_clear_content blackbox
    exit_on_error $?
    do_check_content blackbox
    ret=$?
elif [ $param = "data" ]; then
    do_clear_content data
    exit_on_error $?
    do_check_content data
    ret=$?
elif [ $param = "test" ]; then
    do_clear_content test
    exit_on_error $?
    do_check_content test
    ret=$?
fi

rm -rf $temp_file

if [ ${ret} -eq 0 ]; then
    myecho "clear $param _success_."
    exit 0
else
    myecho "clear $param _fail_"
fi
