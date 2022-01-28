# below video decoding cost about 38 seconds, jpeg decoding cost about 3 seconds
echo "clean last test output video..."
rm -rf /data/dji/amt/codec/out/b3
if [ ! -e /data/dji/amt/codec/in/b3.h264 ]; then
	echo "/data/dji/amt/codec/in/b3.h264 not exist !"
	echo "laohuadec test fail as input video not exist!"
	exit 10
fi
echo "calculating md5 of input file /data/dji/amt/codec/in/b3.h264..."
md5sum /data/dji/amt/codec/in/b3.h264 | busybox grep c50b76aadf1844a4faff972b33461af0
if [ $? != 0 ]; then
	echo "video input md5 is error, should be c50b76aadf1844a4faff972b33461af0"
	echo "laohuadec test fail as input video md5 error!"
	exit 11
fi
echo "clean last test output video md5 file..."
rm -rf /data/dji/amt/codec/dec_b3.md5
echo "clean last test output video crc file..."
rm -rf /data/dji/amt/codec/dec_b3.crc
echo "Begin vdec test ..."
vdec_test -s 1 -t h264 -i /data/dji/amt/codec/in/b3.h264 -dumpyuv 1 -outputpath /data/dji/amt/codec/out/b3 -yuvnameext 1 -fullscan 0 -decoutsleep 60 -dwrperiod 500 -calmd5 2 -md5path /data/dji/amt/codec/dec_b3.md5 -HWCrcGen /data/dji/amt/codec/dec_b3.crc
if [ ! -e /data/dji/amt/codec/out/b3/0_1/dump_0_1920x1080_420p12_8bit.yuv ]; then
	echo "video dec output file not exist !"
	echo "laohuadec test fail as vdec output file not exist!"
	exit 21
fi
echo "Vdec program end !!!"
echo "display md5 calculated from memory:"
cat /data/dji/amt/codec/dec_b3.md5
VDEC_RESULT_MEM=`cat /data/dji/amt/codec/dec_b3.md5`
echo "check vdec memory md5..."
echo $VDEC_RESULT_MEM | busybox grep 6de85607d9e42eca6fac375c39f6e372
if [ $? != 0 ]; then
	echo "md5 from memory should be 6de85607d9e42eca6fac375c39f6e372"
	echo "laohuadec test fail as vdec output md5 error!"
	cat /data/dji/amt/codec/dec_b3.crc
	echo "dmesg info:"
	dmesg | grep -E 'vdec_test|IMGVIDEO-HISR|MMF|d5500-vxd|PicDelimit|vxd0'
	exit 22
fi
#echo "calculating md5 of output file /data/dji/amt/codec/out/b3/0_1/dump_0_1920x1080_420p12_8bit.yuv..."
#sync
#VDEC_RESULT_FILE=`md5sum /data/dji/amt/codec/out/b3/0_1/dump_0_1920x1080_420p12_8bit.yuv`
#echo $VDEC_RESULT_FILE | busybox grep 6de85607d9e42eca6fac375c39f6e372
#if [ $? != 0 ]; then
#	ls -l /data/dji/amt/codec/out/b3/0_1/dump_0_1920x1080_420p12_8bit.yuv
#	echo "video dec output md5 is error, should be 6de85607d9e42eca6fac375c39f6e372"
#	echo "but it's memory md5 is: $VDEC_RESULT_MEM and file md5 is: $VDEC_RESULT_FILE"
#	VDEC_RESULT_FILE2=`md5sum /data/dji/amt/codec/out/b3/0_1/dump_0_1920x1080_420p12_8bit.yuv`
#	echo "calculate file md5 again is: $VDEC_RESULT_FILE2"
#	echo "laohuadec test fail as vdec output md5 error!"
#	echo "dmesg info:"
#	dmesg | grep -E 'vdec_test|IMGVIDEO-HISR|MMF|d5500-vxd|PicDelimit|vxd0'
#	echo $VDEC_RESULT_MEM | busybox grep 6de85607d9e42eca6fac375c39f6e372
#	if [ $? == 0 ]; then
#		echo $VDEC_RESULT_FILE2 | busybox grep 6de85607d9e42eca6fac375c39f6e372
#		if [ $? == 0 ]; then
#			echo "video memory md5 and 2nd file md5 are correct, 1st file md5 error"
#			exit 23
#		fi
#		echo "video memory md5 correct, 1st and 2nd file md5 error"
#		exit 24
#	fi
#	exit 22
#fi

echo "clean last test output jpg..."
rm -rf /data/dji/amt/codec/out/j
if [ ! -e /data/dji/amt/codec/in/1.jpg ]; then
	echo "/data/dji/amt/codec/in/1.jpg not exist !"
	echo "laohuadec test fail as input jpg not exist!"
	exit 50
fi
echo "calculating md5 of input file /data/dji/amt/codec/in/1.jpg..."
md5sum /data/dji/amt/codec/in/1.jpg | busybox grep 2700e70a6e3ce12792bedb72afada6cf
if [ $? != 0 ]; then
	echo "jpg input md5 is error, should be 2700e70a6e3ce12792bedb72afada6cf"
	echo "laohuadec test fail as input jpg md5 error!"
	exit 51
fi
echo "clean last test output jpg md5 file..."
rm -rf /data/dji/amt/codec/jpg_1.md5
echo "clean last test output jpg crc file..."
rm -rf /data/dji/amt/codec/jpg_1.crc
echo "Begin jpg dec test ..."
vdec_test -s 1 -t jpeg -i /data/dji/amt/codec/in/1.jpg -dumpyuv 1 -outputpath /data/dji/amt/codec/out/j -yuvnameext 1 -bitstreambufsize 5000000 -numbitstreambufs 1 -dwrperiod 500 -calmd5 2 -md5path /data/dji/amt/codec/jpg_1.md5 -HWCrcGen /data/dji/amt/codec/jpg_1.crc
if [ ! -e /data/dji/amt/codec/out/j/0_1/dump_0_4000x2992_unknown_8bit.yuv ]; then
	echo "jpg dec output file not exist !"
	echo "laohuadec test fail as jpg dec output file not exist!"
	exit 61
fi
echo "Jpg dec program end !!!"
echo "display md5 calculated from memory:"
cat /data/dji/amt/codec/jpg_1.md5
JDEC_RESULT_MEM=`cat /data/dji/amt/codec/jpg_1.md5`
echo "check jdec memory md5..."
echo $JDEC_RESULT_MEM | busybox grep e64fb93ac38f2367737d975568e11b47
if [ $? != 0 ]; then
	echo "md5 from memory should be e64fb93ac38f2367737d975568e11b47"
	echo "laohuadec test fail as jpg dec output md5 error!"
	cat /data/dji/amt/codec/jpg_1.crc
	echo "dmesg info:"
	dmesg | grep -E 'vdec_test|IMGVIDEO-HISR|MMF|d5500-vxd|PicDelimit|vxd0'
	exit 62
fi
#echo "calculating md5 of output file /data/dji/amt/codec/out/j/0_1/dump_0_4000x2992_unknown_8bit.yuv..."
#sync
#JDEC_RESULT_FILE=`md5sum /data/dji/amt/codec/out/j/0_1/dump_0_4000x2992_unknown_8bit.yuv`
#echo $JDEC_RESULT_FILE | busybox grep e64fb93ac38f2367737d975568e11b47
#if [ $? != 0 ]; then
#	ls -l /data/dji/amt/codec/out/j/0_1/dump_0_4000x2992_unknown_8bit.yuv
#	echo "jpg dec output md5 is error, should be e64fb93ac38f2367737d975568e11b47"
#	echo "but it's memory md5 is: $JDEC_RESULT_MEM and file md5 is: $JDEC_RESULT_FILE"
#	JDEC_RESULT_FILE2=`md5sum /data/dji/amt/codec/out/j/0_1/dump_0_4000x2992_unknown_8bit.yuv`
#	echo "calculate file md5 again is: $JDEC_RESULT_FILE2"
#	echo "laohuadec test fail as jpg dec output md5 error!"
#	echo "dmesg info:"
#	dmesg | grep -E 'vdec_test|IMGVIDEO-HISR|MMF|d5500-vxd|PicDelimit|vxd0'
#	echo $JDEC_RESULT_MEM | busybox grep e64fb93ac38f2367737d975568e11b47
#	if [ $? == 0 ]; then
#		echo $JDEC_RESULT_FILE2 | busybox grep e64fb93ac38f2367737d975568e11b47
#		if [ $? == 0 ]; then
#			echo "jpg memory md5 and 2nd file md5 are correct, 1st file md5 error"
#			exit 63
#		fi
#		echo "jpg memory md5 correct, 1st and 2nd file md5 error"
#		exit 64
#	fi
#	exit 62
#fi

echo "laohuadec test one round succeed !!!"
exit 0
