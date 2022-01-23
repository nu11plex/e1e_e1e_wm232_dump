#!/system/bin/sh

info=`df | grep blackbox | busybox awk '{print $4}'`
if [ $? != 0 ];then
    echo "no blackbox info in df!!!"
    return 1
fi

result=`echo $info | grep M`
if [ $? == 0 ];then
    echo "size is ~M"
    size=`echo ${result%.*}`
    if [ $size -lt 50 ];then
        size=`echo ${result%M*}`
        echo "size $size M is less than 50M, need to format blackbox"
        return 1
    fi
fi

echo $info | grep K
if [ $? == 0 ];then
    echo "size is ~K, err happen and no enough space in blackbox!!"
    return 1
fi

echo "blackbox is normal, size is $info"
return 0
