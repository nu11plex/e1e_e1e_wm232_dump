#!/bin/sh

#
# LED
#

LED_GENERIC_FLAG=01
LED_REQUESTER_ID=0000
LED_IDENTITY_ID=00
LED_PRIORITY=01

LED_SHOWTIME=00
LED_TYPE=00
LED_TIMEOUT=0111
LED_DESCRIPTION=0102030405060708090a

FC_CMDSET=3
REGISTER_LED_CMDID=0xbc
SET_LED_CMDID=0xbe
LED_SET_ACTION_NUM=01
LED_SET_REQUESTER_ID=0000

RED_ON_PRIORITY=02
RED_BLINK_PRIORITY=03
GREEN_ON_PRIORITY=04
GREEN_BLINK_PRIORITY=05

LED_RED_BLINK_ACTION0=010a6464
LED_RED_BLINK_ACTION1=000a6464
LED_RED_BLINK_ACTION2=00000000
LED_RED_BLINK_ACTION3=00000000
LED_RED_BLINK_ACTION4=00000000
LED_RED_BLINK_ACTION5=00000000
LED_RED_BLINK_ACTION6=00000000
LED_RED_BLINK_ACTION7=00000000

LED_RED_ON_ACTION0=010a6464
LED_RED_ON_ACTION1=010a6464
LED_RED_ON_ACTION2=00000000
LED_RED_ON_ACTION3=00000000
LED_RED_ON_ACTION4=00000000
LED_RED_ON_ACTION5=00000000
LED_RED_ON_ACTION6=00000000
LED_RED_ON_ACTION7=00000000

LED_GREEN_BLINK_ACTION0=020a6464
LED_GREEN_BLINK_ACTION1=000a6464
LED_GREEN_BLINK_ACTION2=00000000
LED_GREEN_BLINK_ACTION3=00000000
LED_GREEN_BLINK_ACTION4=00000000
LED_GREEN_BLINK_ACTION5=00000000
LED_GREEN_BLINK_ACTION6=00000000
LED_GREEN_BLINK_ACTION7=00000000

LED_GREEN_ON_ACTION0=020a6464
LED_GREEN_ON_ACTION1=020a6464
LED_GREEN_ON_ACTION2=00000000
LED_GREEN_ON_ACTION3=00000000
LED_GREEN_ON_ACTION4=00000000
LED_GREEN_ON_ACTION5=00000000
LED_GREEN_ON_ACTION6=00000000
LED_GREEN_ON_ACTION7=00000000

red_blink_requester_id=00
red_blink_action_id=00
red_on_requester_id=00
red_on_action_id=00

green_blink_requester_id=00
green_blink_action_id=00
green_on_requester_id=00
green_on_action_id=00

#######################################unregistser#################################################
green_blink_action_unregister()
{
    echo "green_blink_action_unregister: enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbd 0100${green_blink_requester_id}${green_blink_action_id}`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "green_blink_action_unregister: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "green_blink_action_unregister: fc $rr __fail"
        return 2
    fi

    green_blink_requester_id=00
    green_blink_action_id=00
    echo "green_blink_action_unregister: ok"

    return 0
}

green_on_action_unregister()
{
    echo "green_on_action_unregister: enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbd 0100${green_on_requester_id}${green_on_action_id}`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "green_on_action_unregister: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "green_on_action_unregister: fc $rr __fail"
        return 2
    fi

    green_on_requester_id=00
    green_on_action_id=00
    echo "green_on_action_unregister: ok"

    return 0
}

red_blink_action_unregister()
{
    echo "red_blink_action_unregister: enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbd 0100${red_blink_requester_id}${red_blink_action_id}`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "red_blink_action_unregister: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "red_blink_action_unregister: fc $rr __fail"
        return 2
    fi

    red_blink_requester_id=00
    red_blink_action_id=00
    echo "red_blink_action_unregister: ok"

    return 0
}

red_on_action_unregister()
{
    echo "red_on_action_unregister: enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbd 0100${red_on_requester_id}${red_on_action_id}`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "red_on_action_unregister: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "red_on_action_unregister: fc $rr __fail"
        return 2
    fi

    red_on_requester_id=00
    red_on_action_id=00
    echo "red_on_action_unregister: ok"

    return 0
}

#######################################registser#################################################
green_blink_action_register()
{
    echo "green_blink_action_register: enter"

    led_reg_ack=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s $FC_CMDSET -c $REGISTER_LED_CMDID ${LED_GENERIC_FLAG}${LED_REQUESTER_ID}${LED_IDENTITY_ID}${LED_GREEN_BLINK_ACTION0}${LED_GREEN_BLINK_ACTION1}${LED_GREEN_BLINK_ACTION2}${LED_GREEN_BLINK_ACTION3}${LED_GREEN_BLINK_ACTION4}${LED_GREEN_BLINK_ACTION5}${LED_GREEN_BLINK_ACTION6}${LED_GREEN_BLINK_ACTION7}${GREEN_BLINK_PRIORITY}${LED_SHOWTIME}${LED_TYPE}${LED_TIMEOUT}${LED_DESCRIPTION}`
    local ret=$?
    echo $led_reg_ack
    if [ $ret -ne 0 ]; then
        local err_msg=${led_reg_ack##*error:}
        echo "green_blink_action_register: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    raw_data=${led_reg_ack##*data:}
    local rr=`echo $raw_data | busybox awk '{printf $1}'`
    if [[ $rr != "00" && $rr != "0f" ]]; then
        echo "green_blink_action_register: fc $rr __fail"
        return 2
    fi

    result=`echo $raw_data | busybox awk '{printf $1;}'`
    green_blink_requester_id=`echo $raw_data | busybox awk '{printf $2$3;}'`
    green_blink_action_id=`echo $raw_data | busybox awk '{printf $5;}'`

    echo "green_blink_action_register: green_blink_requester_id=$green_blink_requester_id, green_blink_action_id=$green_blink_action_id"
    return 0
}

green_on_action_register()
{
    echo "green_on_action_register: enter"

    led_reg_ack=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s $FC_CMDSET -c $REGISTER_LED_CMDID ${LED_GENERIC_FLAG}${LED_REQUESTER_ID}${LED_IDENTITY_ID}${LED_GREEN_ON_ACTION0}${LED_GREEN_ON_ACTION1}${LED_GREEN_ON_ACTION2}${LED_GREEN_ON_ACTION3}${LED_GREEN_ON_ACTION4}${LED_GREEN_ON_ACTION5}${LED_GREEN_ON_ACTION6}${LED_GREEN_ON_ACTION7}${GREEN_ON_PRIORITY}${LED_SHOWTIME}${LED_TYPE}${LED_TIMEOUT}${LED_DESCRIPTION}`
    local ret=$?
    echo $led_reg_ack
    if [ $ret -ne 0 ]; then
        local err_msg=${led_reg_ack##*error:}
        echo "green_on_action_register: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    raw_data=${led_reg_ack##*data:}
    local rr=`echo $raw_data | busybox awk '{printf $1}'`
    if [[ $rr != "00" && $rr != "0f" ]]; then
        echo "green_on_action_register: fc $rr __fail"
        return 2
    fi

    result=`echo $raw_data | busybox awk '{printf $1;}'`
    green_on_requester_id=`echo $raw_data | busybox awk '{printf $2$3;}'`
    green_on_action_id=`echo $raw_data | busybox awk '{printf $5;}'`

    echo "green_on_action_register: green_on_requester_id=$green_on_requester_id, green_on_action_id=$green_on_action_id"
    return 0
}

red_blink_action_register()
{
    echo "red_blink_action_register: enter"

    led_reg_ack=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s $FC_CMDSET -c $REGISTER_LED_CMDID ${LED_GENERIC_FLAG}${LED_REQUESTER_ID}${LED_IDENTITY_ID}${LED_RED_BLINK_ACTION0}${LED_RED_BLINK_ACTION1}${LED_RED_BLINK_ACTION2}${LED_RED_BLINK_ACTION3}${LED_RED_BLINK_ACTION4}${LED_RED_BLINK_ACTION5}${LED_RED_BLINK_ACTION6}${LED_RED_BLINK_ACTION7}${RED_BLINK_PRIORITY}${LED_SHOWTIME}${LED_TYPE}${LED_TIMEOUT}${LED_DESCRIPTION}`
    local ret=$?
    echo $led_reg_ack
    if [ $ret -ne 0 ]; then
        local err_msg=${led_reg_ack##*error:}
        echo "red_blink_action_register: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    raw_data=${led_reg_ack##*data:}
    local rr=`echo $raw_data | busybox awk '{printf $1}'`
    if [[ $rr != "00" && $rr != "0f" ]]; then
        echo "red_blink_action_register: fc $rr __fail"
        return 2
    fi

    result=`echo $raw_data | busybox awk '{printf $1;}'`
    red_blink_requester_id=`echo $raw_data | busybox awk '{printf $2$3;}'`
    red_blink_action_id=`echo $raw_data | busybox awk '{printf $5;}'`

    echo "red_blink_action_register: red_blink_requester_id=$red_blink_requester_id, red_blink_action_id=$red_blink_action_id"
    return 0
}

red_on_action_register()
{
    echo "red_on_action_register: enter"

    led_reg_ack=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s $FC_CMDSET -c $REGISTER_LED_CMDID ${LED_GENERIC_FLAG}${LED_REQUESTER_ID}${LED_IDENTITY_ID}${LED_RED_ON_ACTION0}${LED_RED_ON_ACTION1}${LED_RED_ON_ACTION2}${LED_RED_ON_ACTION3}${LED_RED_ON_ACTION4}${LED_RED_ON_ACTION5}${LED_RED_ON_ACTION6}${LED_RED_ON_ACTION7}${RED_ON_PRIORITY}${LED_SHOWTIME}${LED_TYPE}${LED_TIMEOUT}${LED_DESCRIPTION}`
    local ret=$?
    echo $led_reg_ack
    if [ $ret -ne 0 ]; then
        local err_msg=${led_reg_ack##*error:}
        echo "red_on_action_register: ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi

    raw_data=${led_reg_ack##*data:}
    local rr=`echo $raw_data | busybox awk '{printf $1}'`
    if [[ $rr != "00" && $rr != "0f" ]]; then
        echo "red_on_action_register: fc $rr __fail"
        return 2
    fi

    result=`echo $raw_data | busybox awk '{printf $1;}'`
    red_on_requester_id=`echo $raw_data | busybox awk '{printf $2$3;}'`
    red_on_action_id=`echo $raw_data | busybox awk '{printf $5;}'`

    echo "red_on_action_register: red_on_requester_id=$red_on_requester_id, red_on_action_id=$red_on_action_id"
    return 0
}

#######################################action#################################################
led_green_blink()
{
    green_blink_action_register

    echo "led_green_blink enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbe 01${green_blink_requester_id}${green_blink_action_id}01`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "led_green_blink ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi
    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "led_green_blink fc $rr __fail"
        return 2
    fi
    echo "led_green_blink ok"
}

led_green_on()
{
    green_on_action_register

    echo "led_green_on enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbe 01${green_on_requester_id}${green_on_action_id}01`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "led_green_on ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi
    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "led_gree_on fc $rr __fail"
        return 2
    fi
    echo "led_green_on ok"
    return 0
}

led_red_blink()
{
    red_blink_action_register

    echo "led_red_blink enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbe 01${red_blink_requester_id}${red_blink_action_id}01`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "led_red_blink ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi
    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "led_red_blink fc $rr __fail"
        return 2
    fi
    echo "led_red_blink ok"
}

led_red_on()
{
    red_on_action_register

    echo "led_red_on enter"
    local r=`dji_mb_ctrl -S test -R local2 -g 3 -t 6 -s 3 -c 0xbe 01${red_on_requester_id}${red_on_action_id}01`
    local ret=$?
    echo $r
    if [ $ret -ne 0 ]; then
        local err_msg=${r##*error:}
        echo "led_red_on ret=$ret, mb_ctrl fc $err_msg __fail"
        return 1
    fi
    local k=${r##*data:}
    local rr=`echo $k | busybox awk '{printf $1}'`
    if [ $rr != "00" ]; then
        echo "led_red_on fc $rr __fail"
        return 2
    fi
    echo "led_red_on ok"
    return 0
}
