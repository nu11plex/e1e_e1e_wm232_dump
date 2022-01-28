#!/system/bin/sh


dsp_load()
{
    local dsp_pre_cnt=0
    local dsp_cur_cnt=0

    dji_dsp_load -n dspimage -d $1 /data/dsp-test-cases/cycles_test_dsp$1.img

    dsp_pre_cnt=`busybox devmem $2`
    usleep 1000
    dsp_cur_cnt=`busybox devmem $2`

    if [ "$dsp_cur_cnt" != "$dsp_pre_cnt" ]
    then
        echo "******************dsp load $1 $2 success*************************"
    else
        echo "******************dsp load $1 $2 fail***************************"
    fi
}

declare -i count=0
while true
do
    dsp_load 0 0xf800fffc
    dsp_load 1 0xf880fffc
    dsp_load 2 0xf900fffc
    dsp_load 3 0xf980fffc
    dsp_load 4 0xfa00fffc
    let ++count
    echo "******************dsp load count ($count) ***************************"
done