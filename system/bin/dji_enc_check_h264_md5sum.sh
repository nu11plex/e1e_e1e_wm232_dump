# below script encoding a yuv seq 3 times and check output h264 stream md5sum
echo "start encoder hardware error detecting..."

#echo "step 0.generate input yuv..."
/system/bin/test_gen_yuv

#echo "step 1.check input yuv..."
if [ ! -e /camera/1920x1080_8bit_3f.nv12 ]; then
  echo "encoder test fail input yuv:/camera/1920x1080_8bit_3f.nv12 not exists";
  exit 1;
fi;

for i in $(seq 1 3)
do
    echo "encoder hardware check running $i times..."
	#echo "step 2.run vxe_testbench to encode input yuv..."
	#vxe_testbench -t H264 -predefinedGOP SingleP -src_w 1920 -src_h 1080 -src_format NV12 -rcMode VBR -encbitrate 10000000 -framerate 30 -framecount 3 -refFBC 0 -bypassFBC 1 -srcyuv /data/src.yuv -recyuv /data/a.yuv -o /data/a.h264
	vxe_testbench -t H264 -predefinedGOP SingleP -src_w 1920 -src_h 1080 -src_format NV12 -rcMode VBR -encbitrate 10000000 -framerate 240 -framecount 3 -numpipestouse 2 -CBPerEncode 4 -slices 2 -srcyuv /camera/1920x1080_8bit_3f.nv12 -o /data/out.h264 > /dev/null
	if [ $? != 0 ]; then
		echo "encoder test fail: vxe_testbench excute fail!"
		rm -rf /data/out.h264
		rm -rf /camera/1920x1080_8bit_3f.nv12
		exit 2
	fi
	#echo "vxe_testbench encoding finished success..."

	#echo "step 3.check encode output h264 md5sum is correct or not..."
	venc_out_264_md5sum=`md5sum -b /data/out.h264`
	venc_correct_264_md5sum=" f7fad515e429052a2497b6383fe3ebbb"
	if [ $venc_out_264_md5sum = $venc_correct_264_md5sum ];
	then
		#echo "Encode hardware check success[$i], output md5: $venc_out_264_md5sum == $venc_correct_264_md5sum :expect md5"
		rm -rf /data/out.h264
		#sleep 1
		#exit 0
	else
		echo "Encode hardware check failed[$i],  output md5: $venc_out_264_md5sum != $venc_correct_264_md5sum :expect md5"
		rm -rf /data/out.h264
		rm -rf /camera/1920x1080_8bit_3f.nv12
		echo -e "\n<<<<<<RESULT>>>>>>: Encode hardware check h264 failed, has hw error......"
		exit 3
	fi
done

for i in $(seq 1 3)
do
    echo "encoder hardware check running $i times..."
	#echo "step 2.run vxe_testbench to encode input yuv..."
	#vxe_testbench -t H264 -predefinedGOP SingleP -src_w 1920 -src_h 1080 -src_format NV12 -rcMode VBR -encbitrate 10000000 -framerate 30 -framecount 3 -refFBC 0 -bypassFBC 1 -srcyuv /data/src.yuv -recyuv /data/a.yuv -o /data/a.h264
	vxe_testbench -t H265 -predefinedGOP SingleP -src_w 1920 -src_h 1080 -src_format NV12 -rcMode VBR -encbitrate 10000000 -framerate 240 -framecount 3 -numpipestouse 2 -CBPerEncode 4 -slices 2 -srcyuv /camera/1920x1080_8bit_3f.nv12 -o /data/out.h264 > /dev/null
	if [ $? != 0 ]; then
		echo "encoder test fail: vxe_testbench excute fail!"
		rm -rf /data/out.h264
		rm -rf /camera/1920x1080_8bit_3f.nv12
		exit 2
	fi
	#echo "vxe_testbench encoding finished success..."

	#echo "step 3.check encode output h264 md5sum is correct or not..."
	venc_out_264_md5sum=`md5sum -b /data/out.h264`
	venc_correct_264_md5sum=" 3620754152fec0faad50bb09d72c0f6c"
	if [ $venc_out_264_md5sum = $venc_correct_264_md5sum ];
	then
		#echo "Encode hardware check success[$i], output md5: $venc_out_264_md5sum == $venc_correct_264_md5sum :expect md5"
		rm -rf /data/out.h264
		#sleep 1
		#exit 0
	else
		echo "Encode hardware check failed[$i],  output md5: $venc_out_264_md5sum != $venc_correct_264_md5sum :expect md5"
		rm -rf /data/out.h264
		rm -rf /camera/1920x1080_8bit_3f.nv12
		echo -e "\n<<<<<<RESULT>>>>>>: Encode hardware check h265 failed, has hw error......"
		exit 3
	fi
done
rm -rf /data/out.h264
rm -rf /camera/1920x1080_8bit_3f.nv12
echo -e "\n<<<<<<RESULT>>>>>>: Encode hardware check h264/h265 success, no hw error........."
exit 0
