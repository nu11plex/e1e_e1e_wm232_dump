get_bsp_fail_reason()
{
    if [ $1 == 1 ]; then
        aging_fail_reason="bsp_cpu"
    elif [ $1 == 2 ]; then
        aging_fail_reason="bsp_ddr"
    elif [ $1 == 3 ]; then
        aging_fail_reason="bsp_emmc_dd"
    elif [ $1 == 4 ]; then
        aging_fail_reason="bsp_emmc_write"
    elif [ $1 == 5 ]; then
        aging_fail_reason="bsp_sd_dd"
    elif [ $1 == 6 ]; then
        aging_fail_reason="bsp_sd_write"
    elif [ $1 == 7 ]; then
        aging_fail_reason="bsp_sd_not_found"
    elif [ $1 == 8 ]; then
        aging_fail_reason="bsp_no_sample_data"
    else
        aging_fail_reason="unknown"
    fi

    echo $aging_fail_reason
}

get_perception_fail_reason()
{
    if [ $1 == 1 ]; then
        aging_fail_reason="syslog contains error"
    elif [ $1 == 2 ]; then
        aging_fail_reason="load image fail"
    elif [ $1 == 3 ]; then
        aging_fail_reason="usb init fail"
    elif [ $1 == 4 ]; then
        aging_fail_reason="fname file not exist"
    elif [ $1 == 5 ]; then
        aging_fail_reason="connection.log file not exist"
    elif [ $1 == 6 ]; then
        aging_fail_reason="syslog overflow"
    elif [ $1 == 7 ]; then
        aging_fail_reason="reset"
    else
        aging_fail_reason="unknown"
    fi

    echo $aging_fail_reason
}

get_navigation_fail_reason()
{
    if [ $1 == 2 ]; then
        aging_fail_reason="nav_dsp2_fail"
    elif [ $1 == 3 ]; then
        aging_fail_reason="nav_dsp3_fail"
    else
        aging_fail_reason="unknown"
    fi

    echo $aging_fail_reason
}

get_camera_fail_reason()
{
    if [ $1 == 1 ]; then
        aging_fail_reason="set capture workmode"
    elif [ $1 == 2 ]; then
        aging_fail_reason="set record workmode"
    elif [ $1 == 3 ]; then
        aging_fail_reason="set playback workmode"
    elif [ $1 == 4 ]; then
        aging_fail_reason="start record"
    elif [ $1 == 5 ]; then
        aging_fail_reason="check recording status"
    elif [ $1 == 6 ]; then
        aging_fail_reason="start video playback"
    elif [ $1 == 7 ]; then
        aging_fail_reason="stop video playback"
    elif [ $1 == 8 ]; then
        aging_fail_reason="stop record"
    elif [ $1 == 9 ]; then
        aging_fail_reason="single capture"
    elif [ $1 == 10 ]; then
        aging_fail_reason="burst capture"
    elif [ $1 == 11 ]; then
        aging_fail_reason="AEB capture"
    elif [ $1 == 12 ]; then
        aging_fail_reason="formart sd card"
    elif [ $1 == 13 ]; then
        aging_fail_reason="get video dcf info"
    elif [ $1 == 14 ]; then
        aging_fail_reason="input argument"
    elif [ $1 == 15 ]; then
        aging_fail_reason="set record video format"
    elif [ $1 == 16 ]; then
        aging_fail_reason="lens drop step"
    elif [ $1 == 17 ]; then
        aging_fail_reason="set MF"
    elif [ $1 == 18 ]; then
        aging_fail_reason="set set expo mode"
    else
        aging_fail_reason="unknown"
    fi

    echo $aging_fail_reason
}

get_codec_fail_reason()
{
    if [ $1 == 10 ]; then
        aging_fail_reason="input_video_not_exist"
    elif [ $1 == 11 ]; then
        aging_fail_reason="input_video_md5_error"
    elif [ $1 == 21 ]; then
        aging_fail_reason="vdec_output_not_exist"
    elif [ $1 == 22 ]; then
        aging_fail_reason="vdec_output_md5_error"
    elif [ $1 == 50 ]; then
        aging_fail_reason="input_jpg_not_exist"
    elif [ $1 == 51 ]; then
        aging_fail_reason="input_jpg_md5_error"
    elif [ $1 == 61 ]; then
        aging_fail_reason="jdec_output_not_exist"
    elif [ $1 == 62 ]; then
        aging_fail_reason="jdec_output_md5_errorargument"
    else
        aging_fail_reason="unknown"
    fi

    echo $aging_fail_reason
}
