#! /system/bin/sh

stop dji_camera2

sleep 2

if [ $# != 1 ];then
    dji_cht -c still_16x9_j_bin4
else
    if [ $1 == 'j' ];then
        dji_cht -c still_16x9_j_bin4
    fi

    if [ $1 == 'r' ];then
        dji_cht -c still_16x9_r_bin4
    fi

    if [ $1 == 'jandr' ];then
        dji_cht -c still_16x9_jandr_bin4
    fi
fi

start dji_camera2
