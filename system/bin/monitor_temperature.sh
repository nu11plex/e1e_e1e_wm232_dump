#!/system/bin/sh

CHNL0=00
CHNL1=01
CHNL2=02
CHNL3=03
CHNL4=04
ENV_CHNL=05
save=0
seq=0
get_chnl_temp()
{
    let seq=seq+1
    local result=`dji_mb_ctrl -S test -R diag -q $seq -g 3 -t 6 -s 0 -c 0x54 $1 `

    local ret=$?
    #echo $result
    if [ $ret != 0 ];then
        local err_msg=${result##*error:}
        echo "get_chnl_temp ret=$ret, mb_ctrl fc $err_msg __warning."
        echo $result
        return 1
    fi
    local raw_data=${result##*data:}

    result=`echo $raw_data | busybox awk '{printf $1}'`
    if [ $result != "00" ]; then
        echo "get_chnl_temp result=$result, fc __warning."
        return 2
    fi

    local temp_hex=`echo $raw_data | busybox awk '{printf $3$2}'`
    ((temp=16#$temp_hex))
    echo $temp
    return 0

}

get_ofdm_temp()
{
    let seq=seq+1
    local result=`dji_mb_ctrl -S test -R diag -q $seq -g 9 -t 0 -s 0 -c 0x54 00`
    local ret=$?
    #echo $result
    #echo $ret
    if [ $ret != 0 ];then
        local err_msg=${result##*error:}
        echo "get_ofdm_temp ret=$ret, mb_ctrl 0900 $err_msg __warning."
        echo $result
        return 1
    fi
    raw_data=${result##*data:}

    result=`echo $raw_data | busybox awk '{printf $1}'`
    if [ $result != "00" ]; then
        echo "get_ofdm_temp result=$result, 0900 __warning."
        return 2
    fi

    local temp_hex=`echo $raw_data | busybox awk '{printf $3$2}'`
    ((temp=16#$temp_hex))
    echo $temp
    return 0
}

LIMIT_CHN=1100
LIMIT_OFDM=1100

main()
{
local main_ret=0
local err_eag=1
local sub_ret=0
temp00=`get_chnl_temp 00`
sub_ret=$?
if [ $sub_ret -ne 0 ]; then
    temp00=0
fi
temp01=`get_chnl_temp 01`
sub_ret=$?
if [ $sub_ret -ne 0 ]; then
    temp01=0
fi
temp02=`get_chnl_temp 02`
sub_ret=$?
if [ $sub_ret -ne 0 ]; then
    temp02=0
fi
temp03=`get_chnl_temp 03`
sub_ret=$?
if [ $sub_ret -ne 0 ]; then
    temp03=0
fi
temp04=`get_chnl_temp 04`
sub_ret=$?
if [ $sub_ret -ne 0 ]; then
    temp04=0
fi
#temp_ofdm=`get_ofdm_temp`
#sub_ret=$?
#if [ $sub_ret -ne 0 ]; then
#    temp_ofdm=0
#fi

if [ $temp00 -lt $LIMIT_CHN ]; then
if [ $temp01 -lt $LIMIT_CHN ]; then
if [ $temp02 -lt $LIMIT_CHN ]; then
if [ $temp03 -lt $LIMIT_CHN ]; then
if [ $temp04 -lt $LIMIT_CHN ]; then
    err_eag=0
fi
fi
fi
fi
fi

if [ $err_eag -ne 0 ]; then
    echo "temperature eagle $temp00 $temp01 $temp02 $temp03 $temp04 __warning"
    main_ret=1
fi

#if [ $temp_ofdm -ge $LIMIT_OFDM ]; then
#    echo "temperature ofdm $temp_ofdm __warning"
#    ((main_ret=$main_ret+2))
#fi

echo "system temperature info: $temp00 $temp01 $temp02 $temp03 $temp04 $temp_ofdm"
return $main_ret
}

main
# ensure collect temperature while continue even if aging test fail
exit 0
