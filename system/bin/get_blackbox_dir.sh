#!/system/bin/sh

## USAGE: get_blackbox_dir.sh $root_dir $target_dir_name $sorties_limit
## return directory
## example: get_blackbox_dir.sh blackbox/system fatal 10
##          /blackbox/system/fatal/fatalxxx

## SETTINGS:
## directory settings
root_dir="$1"
target_dir_name="$2"
## limit settings
sorties_limit=$3

latest_file_name="latest"



## check if target directory exist
target_dir="$root_dir/$target_dir_name"
if [ ! -d $target_dir ]; then
	mkdir -p $target_dir
fi

## check if latest file exist
latest_file="$target_dir/$latest_file_name"
if [ ! -f $latest_file ]; then
	echo "0 / $sorties_limit" > $latest_file
else
	cat_str=`cat $latest_file`
	last_index=`echo ${cat_str%%/*}`
	cur_index=`expr $last_index + 1`
	if  [ $cur_index -ge $sorties_limit ]; then
		cur_index=0
	fi
	echo "$cur_index / $sorties_limit" > $latest_file
fi

## check if there is directory-index over sorties_limit
for file in $target_dir/*; do
	tmp_file_name=`echo ${file##*/}`
	tmp_first_name=${tmp_file_name%%-*}
	tmp_index=`echo $tmp_first_name | tr -cd "[0-9]"`
	if [ -n "$tmp_index" ] && [ $tmp_index -ge $sorties_limit ]; then
		rm -rf $file
	fi
done

## check if directory-index is already exist
tmp_index=`printf "%03s\n" $cur_index`
tmp_dir="$target_dir/$target_dir_name$tmp_index"
#time_suffix=`date +%Y_%m_%d-%H_%M_%S`
dir_name=$tmp_dir
if [ ! -d $tmp_dir* ]; then
	mkdir -p $dir_name
else
	rm -rf $tmp_dir*
	mkdir -p $dir_name
fi

echo "$dir_name"
