stop_service()
{
    echo "stop_service enter"
    setprop dji.blackbox_service 0
    setprop dji.monitor_service 0
    #setprop dji.system_service 0
    #setprop dji.vtwo_sdk_service 0
    setprop dji.perception_service 0
    setprop dji.navigation_service 0
    #setprop dji.camera_service 0
    #setprop dji.rcam_service 0
    setprop dji.flight_service 0
    #setprop dji.amt_service 0
    setprop dji.sec_service 0
    setprop dji.app_agent_service 0
    setprop dji.sdrs_agent_service 0
    setprop ss_dsp_manager_service 0
    echo "stop_service ok"
}

myecho()
{
    echo "[$(date)] $*"
}

do_clear_system()
{
    myecho "do_clear_system enter"
    rm -rf /blackbox/system/*
    myecho "system done"
    rm -rf /blackbox/navigation/*
    rm -rf /blackbox/navigation_fc/*
    myecho "navigation"
    rm -rf /blackbox/dji_app_agent/*
    myecho "dji_app_agent"
    rm -rf /blackbox/camera/*
    myecho "camera"
    rm -rf /blackbox/flyctrl/*
    myecho "flyctrl"
    rm -rf /blackbox/dji_flight/*
    myecho "flight"
    rm -rf /blackbox/dji_perception/*
    myecho "perception"
    rm -rf /blackbox/adsb/*
    myecho "adsb"
    rm -rf /blackbox/sdrs_log/*
    myecho "sdrs_log"
    rm -rf /blackbox/ss_dsp_manager/*
    myecho "ss_dsp_manager"

    rm -rf /data/tombstones/*
    myecho "tombstones"
    rm -rf /data/dji/amt/*
    myecho "amt"
    rm -rf /data/coredump
    myecho "coredump"
    rm -rf /data/burying.db
    myecho "burying"
    rm -rf /data/power_on_times.txt
    myecho "power_on_times"

    myecho "reset storage exportable property"
    setprop persist.dji.storage.exportable 1

    sync
    myecho "do_clear_system ok"
    return 0
}

do_clear_nav()
{
    myecho "do_clear_nav enter"
    rm -rf /data/dji_navigation
    sync
    myecho "do_clear_nav ok"
    return 0
}

do_clear_perception()
{
    myecho "do_clear_perception enter"
    rm -rf /blackbox/dji_perception
    sync
    myecho "do_clear_perception ok"
    return 0
}

do_clear_camera()
{
    local r
    local ret
    myecho "do_clear_camera enter"
    rm -f /data/camera/*
    r=`dji_mb_ctrl -S test -R diag -g 1 -t 0 -s 2 -c 72 01`
    ret=$?
    if [ $ret -ne 0 ]; then
        myecho "mb_ctrl failed, ret=$ret, result=$r"
        r=`dji_mb_ctrl -S test -R diag -g 1 -t 0 -s 2 -c 72 01`
        ret=$?
        if [ $ret -ne 0 ]; then
            myecho "mb_ctrl failed twice, ret=$ret, result=$r"
            return 39
        fi
    fi
    rm -f /data/camera_current.tsf
    rm -f /data/dji_camera.usf
    sync
    setprop dji.camera_service 0
    myecho "do_clear_camera ok"
    return 0
}

do_clear_autotest()
{
    myecho "do_clear_autotest enter"
    rm -rf /data/sdk
    rm -rf /blackbox/autotest
    rm -rf /blackbox/autoflight
    rm -rf /data/dist6m_conf/*
    rm -rf /camera/TestReport
    sync
    myecho "do_clear_autotest ok"
}

do_check_system()
{
    local r
    local cmd
    local ret

    echo "do_check_system enter"

    r=`busybox du -s -m /cache | busybox awk '{print $1}'`
    ret=$?
    if [[ "$r"x = ""x || $ret -ne 0 ]]; then
        echo "du /cache $r fail, ret=$ret result=$r"
        return 2
    fi
    if [ $r -gt 10 ]; then
        echo "du /cache $r fail, ret=$ret result=$r"
        return 2
    fi

    if [ -e /data/dji ] ; then
        r=`busybox du -s -m /data/dji | busybox awk '{print $1}'`
        ret=$?
        if [[ "$r"x = ""x || $ret -ne 0 ]]; then
            echo "/data/dji $r fail, ret=$ret result=$r"
            return 3
        fi
        if [ $r -gt 10 ]; then
            echo "/data/dji $r fail, ret=$ret result=$r"
            return 3
        fi
    fi
    r=`busybox du -s -m /blackbox | busybox awk '{print $1}'`
    ret=$?
    if [[ "$r"x = ""x || $ret -ne 0 ]]; then
        echo "/blackbox $r fail, ret=$ret result=$r"
        return 4
    fi
    # keep upgrade images backups
    if [ $r -gt 400 ]; then
        echo "/blackbox $r fail, ret=$ret result=$r"
        return 4
    fi

    echo "do_check_system ok"
    return 0
}

do_check_nav()
{
    echo "do_check_nav enter"
    if [ -e /data/dji_navigation ]; then
        echo "check nav fail!"
        return 11
    fi
    echo "do_check_nav ok"
    return 0
}

do_check_perception()
{
    echo "do_check_perception enter"
    if [ -e /blackbox/dji_perception ]; then
        echo "check perception fail!"
        return 21
    fi
    echo "do_check_perception ok"
    return 0
}

do_check_camera()
{
    local r
    local ret

    echo "do_check_camera enter"
    if [ -e /data/camera_current.tsf ]; then
        echo "check camera fail!"
        return 31
    fi

    if [ -e /data/dji_camera.usf ]; then
        echo "check camera fail!"
        return 32
    fi

    if [ -e /data/camera ]; then
        r=`busybox du -s -m /data/camera | busybox awk '{print $1}'`
        ret=$?
        if [[ "$r"x = ""x || $ret -ne 0 ]]; then
            echo "/data/camera $r fail, ret=$ret result=$r"
            return 33
        fi
        if [ $r -gt 10 ]; then
            echo "/data/camera $r fail, ret=$ret result=$r"
            return 33
        fi
    fi

    echo "do_check_caemra ok"
    return 0
}

do_check_autotest()
{
    local r
    local ret

    if [ -e /data/sdk ]; then
        r=`busybox du -s -m /data/sdk | busybox awk '{print $1}'`
        ret=$?
        if [[ "$r"x = ""x || $ret -ne 0 ]]; then
            echo "eval $r fail, ret=$ret result=$r"
            return 41
        fi
        if [ $r -gt 10 ]; then
            echo "eval $r fail, ret=$ret result=$r"
            return 41
        fi
    fi

    if [ -e /data/dist6m_conf ]; then
        r=`busybox du -s -m /data/dist6m_conf | busybox awk '{print $1}'`
        ret=$?
        if [[ "$r"x = ""x || $ret -ne 0 ]]; then
            echo "eval $r fail, ret=$ret result=$r"
            return 42
        fi
        if [ $r -gt 10 ]; then
            echo "eval $r fail, ret=$ret result=$r"
            return 42
        fi
    fi

    if [ -e /camera/TestReport ]; then
        r=`busybox du -s -m /camera/TestReport | busybox awk '{print $1}'`
        ret=$?
        if [[ "$r"x = ""x || $ret -ne 0 ]]; then
            echo "eval $r fail, ret=$ret result=$r"
            return 43
        fi
        if [ $r -gt 10 ]; then
            echo "eval $r fail, ret=$ret result=$r"
            return 43
        fi
    fi

    return 0
}

prepare_all()
{
    test_hal_storage -c "0 volume detach_pc"
    stop_service
}

clear_all()
{
    local r
    local cmd
    local ret

    myecho "clear_all enter"

    cmd='do_clear_nav'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    cmd='do_clear_perception'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    cmd='do_clear_camera'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    cmd='do_clear_autotest'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi
    cmd='do_clear_system'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    myecho "clear_all ok"
    return 0
}

check_all()
{
    local r
    local cmd
    local ret

    echo "check_all enter"

    cmd='do_check_nav'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    cmd='do_check_perception'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    cmd='do_check_camera'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    cmd='do_check_autotest'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    cmd='do_check_system'
    $cmd
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "eval $cmd fail, ret=$ret"
        return $ret
    fi

    echo "check_all ok"
    return 0
}

df
busybox df -i

cmd='prepare_all'
$cmd
ret=$?
if [ $ret -ne 0 ]; then
    echo "eval $cmd fail, ret=$ret"
    exit $ret
fi

cmd='clear_all'
$cmd
ret=$?
if [ $ret -ne 0 ]; then
    echo "eval $cmd fail, ret=$ret"
    exit $ret
fi

#cmd='check_all'
#$cmd
#ret=$?
#if [ $ret -ne 0 ]; then
#    echo "eval $cmd fail, ret=$ret"
#    exit $ret
#fi

exit 0
