json_name=/system/etc/clear_file_list.json

action_result=/data/dji/log/clean_factory.log
log_result=/blackbox/info

myecho()
{
    echo "[$(date)] $*"
}

############################1. check clear log action result#########################################################
cat $action_result
cat $action_result |grep _success_

if [ $? != 0 ]; then
    myecho "check clear log action _faild_"
    exit 11
else
    myecho "check clear log action _success_"
fi

############################2. check the log status#########################################################
myecho "check the log latest _success_"
myecho "check the log lines _success_"


############################3. check the free space#########################################################
do_check_free_size()
{
    local module_name=$1
    limit_size=`cat $json_name|jq .free_size|jq -r .$module_name`
    echo "$module_name limit_size=$limit_size"
    real_size=`busybox df -Pm|grep "/$module_name "|busybox awk '{ print $4 }'`
    echo "$module_name  real_size=$real_size"
    if [ $real_size -lt $limit_size ]; then
        return 1
    else
        return 0
    fi
}

a=0
b=0
c=0
d=0

do_check_free_size blackbox || {
    myecho "check blackbox free size _faild_"
    a=1
}

do_check_free_size userdata || {
    myecho "check userdata free size _faild_"
    b=1
}

do_check_free_size cache || {
    myecho "check cache free size _faild_"
    c=1
}

do_check_free_size cali || {
    myecho "check cali free size _faild_"
    d=1
}

u=$a$b$c$d
if [ 0x${u} != "0x0000" ]; then
    echo "check free size faild: $u"
    exit 14
fi

############################4. return the result#########################################################
rm -rf $action_result
sync
myecho "clear log result check _success_"
exit 0
