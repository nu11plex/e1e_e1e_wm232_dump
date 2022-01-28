dir="$(cd $(dirname $0) && pwd)"

test_case_list=(
"$dir/test_dji_camera_entrance.sh"
"$dir/test_dji_camera_entrance.sh -p"
"$dir/test_dji_camera_entrance.sh -q"
"$dir/test_dji_camera_entrance.sh -g"
"$dir/test_dji_camera_entrance.sh -x"
"$dir/test_dji_camera_entrance.sh -p -q"
"$dir/test_dji_camera_entrance.sh -g -p"
"$dir/test_dji_camera_entrance.sh -q test_seq"
"$dir/test_dji_camera_entrance.sh -g unknow_group"
"$dir/test_dji_camera_entrance.sh -g cht"
"$dir/test_dji_camera_entrance.sh -p common/dcam_frwk -q"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk -q"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk -q unknown_query"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk -q test_seq"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk,"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk -g cht"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk -g cst"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk -g pbt"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk -g ppt"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk,dcamgit:service/rcam_user -q test_seq"
"$dir/test_dji_camera_entrance.sh -p dcamgit:common/dcam_frwk,dcamgit:service/rcam_user"
"$dir/test_dji_camera_entrance.sh -p dcamgit:service/rcam_user -q test_seq"
"$dir/test_dji_camera_entrance.sh -p dcamgit:service/rcam_user"
"$dir/test_dji_camera_entrance.sh -p dcamgit:service/rcam_user -g cht"
"$dir/test_dji_camera_entrance.sh -p dcamgit:service/rcam_user -g cst"
"$dir/test_dji_camera_entrance.sh -p dcamgit:service/rcam_user -g pbt"
"$dir/test_dji_camera_entrance.sh -p dcamgit:service/rcam_user -g ppt"
"$dir/test_dji_camera_entrance.sh -p all -q test_seq"
"$dir/test_dji_camera_entrance.sh -p all"
"$dir/test_dji_camera_entrance.sh -p all -g cht"
"$dir/test_dji_camera_entrance.sh -p all -g cst"
"$dir/test_dji_camera_entrance.sh -p all -g pbt"
"$dir/test_dji_camera_entrance.sh -p all -g ppt"
)

main()
{
    for i in "${!test_case_list[@]}"
    do
        local test_case=${test_case_list[$i]}
        echo "================================================================================"
        echo $test_case
        echo "--------------------------------------------------------------------------------"
        eval $test_case
        echo
    done
}

main "$@"
