##     check /blackbox/navigation/dsp*.log
#
##     return value: 0: every dsp running okay
##                   2: dsp2 contains error
##                   3: dsp3 contains error
##                   4: dsp4 contains error
##
##
##
##    used for e1e platform
ret=0
nav_log_path='/blackbox/navigation/'
function ck1(){
busybox awk -F ' ' '
BEGIN{count=0}
function f3(){
    if ($2 == "E" || $2 == "F"){
        count++
    }
}
{
f3()
}
END{print count}
' $1
}
function print_error_msg(){
echo "error message"
busybox awk -F ' ' '
function f3(){
    if ($2 == "E" || $2 == "F"){
        print $0
    }
}
{
f3()
}
' $1
}

function searchContext()
{
    errCount=$(ck1 $1)
    echo "error Count == $errCount"
    if [ $errCount == 0 ]; then
        return 1;
    else
        return 0;
    fi
}
function retProcess()
{
   case $ret in
      0)
     echo "no error"
     exit 0;
     ;;
      2) echo "dsp2 contains error"
     exit 2
     ;;
      3) echo "dsp3 contains error"
     exit 3
     ;;
    4) echo "dsp4 contains error"
    exit 4
    ;;
    5) echo "dsp log dir not contains"
    exit 5
     ;;
   esac
}
function main()
{
    echo "dji_navigation test begin"
    log_index=0
    latest="$nav_log_path""emmc_index"
    echo $latest
    log_index=`sed -n '1p' $latest`
    echo $log_index
    log_dir="$nav_log_path$log_index"
    ret=0
    for dsp_id in 2 3 4
    do
        for index in 4 3 2 1 0
        do
            log_path="$log_dir""/dsp""$dsp_id""_log""$index.txt"
            if [ -f $log_path ];then
                echo "log_path=$log_path"
                searchContext $log_path
                if [ $? == 0 ];then
                    ret=$dsp_id
                    echo "$log_path log contains error"
                    print_error_msg $log_path
                fi
                break;
            fi
        done
    done
    echo "dji_navigation test end"
}
main
retProcess
