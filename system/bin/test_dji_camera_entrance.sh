#! /system/bin/sh

readonly TRUE=0
readonly FALSE=1
readonly RETRY_INFINITE=-1
readonly RETRY_MAX=1800
readonly RETRY_INTERVAL=1
readonly INPUT_DATA_NOT_CHANGE_MAX=10
readonly GIT_PROJECT_DELIMITER=","
readonly KEY_VALUE_DELIMITER="="
readonly TEST_GROUP_CONF_DIR="/system/etc"
readonly WHITELIST_CONF_DIR="/system/etc"

whitelist_enabled=$FALSE
git_project_list=()
query_cmd=""
test_group_to_be_run=""
input_data_space_usage=-1
input_data_not_change_counter=0

test_group_list=()
test_program_list=()
test_timeout_list=()
src_data_git_list=()
src_data_path_list=()
des_data_path_list=()
log_file_list=()

show_usage()
{
    printf "Usage: %s [-p <git_project_list>] [-q test_seq] [-g <test_group>] [-h]\n" $0 >&2
    printf "Get test_group sequence:                       %s -p <dcamgit:git1,dcamgit:git2,shgit:gita,shgit:gitb,...> -q test_seq\n" $0 >&2
    printf "Run all test_group using whitelist:            %s -p <dcamgit:git1,dcamgit:git2,shgit:gita,shgit:gitb,...>\n" $0 >&2
    printf "Run all test_group without using whitelist:    %s\n" $0 >&2
    printf "Run single test_group using whitelist:         %s -p <dcamgit:git1,dcamgit:git2,shgit:gita,shgit:gitb,...> -g <test_group>\n" $0 >&2
    printf "Run single test_group without using whitelist: %s -g <test_group>\n\n" $0 >&2
    printf "\t-p <git_projects_list>        Specify changed git projects list.\n" >&2
    printf "\t-q test_seq                   Print test_group sequence to stdout without running any test.\n" >&2
    printf "\t-g <test_group>               Specify test_group to be run.\n" >&2
    printf "\t-h                            Show this help screen.\n" >&2
    printf "Example:\n" >&2
    printf "\t1. Get test_group sequence that need to be executed if git projects 'dcamgit:git1', 'dcamgit:git2', 'shgit:gita' and 'shgit:gitb' have been changed:\n" >&2
    printf "\t\t%s -p dcamgit:git1,dcamgit:git2,shgit:gita,shgit:gitb -q test_seq\n" $0 >&2
    printf "\n\t2. Run test_group sequences that need to be executed if git projects 'dcamgit:git1', 'dcamgit:git2', 'shgit:gita' and 'shgit:gitb' have been changed:\n" >&2
    printf "\t\t%s -p dcamgit:git1,dcamgit:git2,shgit:gita,shgit:gitb\n" $0 >&2
    printf "\n\t3. Run cht test_group using whitelist:\n" >&2
    printf "\t\t%s -p dcamgit:git1,dcamgit:git2,shgit:gita,shgit:gitb -g cht\n" $0 >&2
    printf "\n\t3. Run cht test_group without using whitelist:\n" >&2
    printf "\t\t%s -g cht\n" $0 >&2
    printf "\n\t4. Run all test_group sequences unconditionally:\n" >&2
    printf "\t\t%s\n\n" $0 >&2
}

get_test_script_dir()
{
    echo $(cd $(dirname $0) && pwd)
}

get_test_group_conf_dir()
{
    echo "$TEST_GROUP_CONF_DIR"
}

get_whitelist_conf_dir()
{
    echo "$WHITELIST_CONF_DIR"
}

enable_whitelist()
{
    whitelist_enabled=$TRUE
}

is_whitelist_enabled()
{
    return $whitelist_enabled
}

is_string_start_with()
{
    local str=$1
    local prefix=$2
    case "$str" in
        "$prefix"*)
                return $TRUE
                ;;
        *)
                return $FALSE
                ;;
    esac
}

is_string_contain()
{
    local str=$1
    local target=$2
    if test "${str#*$target*}" = "$str"; then
        return $FALSE
    else
        return $TRUE
    fi
}

is_number()
{
    local var=$1
    case ${var#[-+]} in
        *[!0-9]* | '')
            return $FALSE
            ;;
        *)
            return $TRUE
            ;;
    esac
}

trim_space()
{
    local str=$1
    str=${str#"${str%%[!$' \t']*}"}
    str=${str%"${str##*[!$' \t']}"}
    printf '%s' "$str"
}

is_string_blank()
{
    local str=$1
    str=$(trim_space "$str")
    test -z "$str"
}

is_git_project_all()
{
    local name=$1
    test "$name" = "all"
}

check_git_project_name()
{
    local name=$1

    if is_string_blank "$name"; then
        return $FALSE
    fi

    if is_git_project_all "$name"; then
        return $TRUE
    fi

    if is_string_start_with "$name" "-"; then
        return $FALSE
    fi

    if ! is_string_contain "$name" ":"; then
        return $FALSE
    fi

    return $TRUE
}

parse_git_project_list()
{
    local str="$1"
    local delimiter=$2
    local i=0

    while test "$str"
    do
        local git=${str%%${delimiter}*}
        if ! check_git_project_name "$git"; then
            printf "%s: invalid git project name: '%s'\n" $0 "$git" >&2
            return $FALSE
        fi

        git_project_list[$i]="$git"

        if test "$str" = "$git"; then
            str=""
        else
            str="${str#*${delimiter}}"
        fi

        i=$(expr $i + 1)
    done

    return $TRUE
}

get_whitelist_filename()
{
    local test_group=$1
    echo "whitelist_${test_group}.conf"
}

get_quick_test_script_name()
{
    local test_group=$1
    echo "test_dji_${test_group}_quick.sh"
}

get_full_test_script_name()
{
    local test_group=$1
    echo "test_dji_${test_group}.sh"
}

is_test_need_input_data()
{
    local test_group=$1
    local des_data_path=$(get_des_data_path $test_group)
    if test "$des_data_path"; then
        return $TRUE
    else
        return $FALSE
    fi
}

find_line_in_file()
{
    local word=$1
    local filename=$2
    local status
    grep -w -- "${word}" "${filename}"
}

find_git_in_whitelist()
{
    local git=$1
    local whitelist_file=$2
    local line
    line=$(find_line_in_file $git $whitelist_file)
}

is_whitelist_hit()
{
    local test_group=$1
    local dir=$(get_whitelist_conf_dir)
    local file=$(get_whitelist_filename "$test_group")
    local whitelist_file="$dir/$file"
    local i

    for i in "${!git_project_list[@]}"
    do
        local git=${git_project_list[$i]}
        if is_git_project_all "$git"; then
            return $TRUE
        fi

        if find_git_in_whitelist "$git" "$whitelist_file"; then
            return $TRUE
        fi
    done

    return $FALSE
}

read_conf_item()
{
    local key="$1"
    local file="$2"
    local line=""
    if line=$(find_line_in_file "$key" "$file"); then
        value=${line#*${KEY_VALUE_DELIMITER}}
        echo $value
    fi
}

query_test_seq()
{
    if ! is_whitelist_enabled; then
        printf "%s: git project list missing while querying test sequence\n" $0 >&2
        return $FALSE
    fi

    local test_group_count=0
    local result=""
    local i

    for i in "${!test_group_list[@]}"
    do
        local test_group=${test_group_list[$i]}
        if ! is_whitelist_hit "$test_group"; then
            if ! is_quick_test_script_exist "$test_group"; then
                continue
            fi
        else
            if ! is_full_test_script_exist "$test_group"; then
                printf "%s: error: full test script '%s' doesn't exist\n" $0 "$(get_full_test_script_name)" >&2
                return $FALSE
            fi
        fi

        result+="test_group: ${test_group_list[$i]}"
        result+=", test_program: ${test_program_list[$i]}"
        result+=", timeout: ${test_timeout_list[$i]}"
        result+=", src_data_git: ${src_data_git_list[$i]}"
        result+=", src_data_path: ${src_data_path_list[$i]}"
        result+=", des_data_path: ${des_data_path_list[$i]}"
        result+=", log_file: ${log_file_list[$i]}"
        result+="\n"

        test_group_count=$(expr $test_group_count + 1)
    done

    echo "total_test_group_count: $test_group_count\n$result"

    return $TRUE
}

handle_query()
{
    local cmd=$1

    case $cmd in
        test_seq)
            query_cmd="$cmd"
            return $TRUE
            ;;
        *)
            printf "%s: unexpected query cmd: %s\n" $0 $cmd >&2
            return $FALSE
            ;;
    esac
}

check_test_group_name()
{
    local name=$1

    if is_string_blank "$name"; then
        printf "[ERR] test_group name is blank\n" >&2
        return $FALSE
    fi

    if is_string_start_with "$name" "-"; then
        return $FALSE
    fi

    return $TRUE
}

set_test_group_to_be_run()
{
    local test_group=$1

    if ! check_test_group_name "$test_group"; then
        printf "%s: invalid test_group name: '%s'\n" $0 "$test_group" >&2
        return $FALSE
    fi

    test_group_to_be_run="$test_group"

    return $TRUE
}

parse_cmd_line()
{
    local OPTIND
    local option
    local arg
    while getopts ":p:q:g:h" option
    do
        case $option in
            g)
                if ! set_test_group_to_be_run "$OPTARG"; then
                    return $FALSE
                fi
                ;;
            h)
                show_usage
                exit $TRUE
                ;;
            p)
                local arg="$OPTARG"
                if ! parse_git_project_list "$arg" $GIT_PROJECT_DELIMITER; then
                    return $FALSE
                fi

                enable_whitelist
                ;;
            q)
                if ! handle_query "$OPTARG"; then
                    return $FALSE
                fi
                ;;
            \:)
                printf "%s: argument missing from -%s option\n" $0 $OPTARG >&2
                return $FALSE
                ;;
            \?)
                printf "%s: unknown option: -%s\n" $0 $OPTARG >&2
                return $FALSE
                ;;
        esac
    done

    shift $(expr $OPTIND - 1)
    if test $# -gt 0; then
        printf "%s: unknown non-option parameter: %s\n" $0 $1 >&2
        return $FALSE
    fi

    return $TRUE
}

get_quick_test_script_path()
{
    local test_group=$1
    local script_path="$(get_test_script_dir)/$(get_quick_test_script_name $test_group)"
    echo $script_path
}

is_quick_test_script_exist()
{
    local test_group=$1
    local script_path="$(get_quick_test_script_path $test_group)"
    test -f "$script_path"
}

run_quick_test()
{
    local test_group=$1
    local script_path="$(get_quick_test_script_path $test_group)"
    if ! test -f "$script_path"; then
        printf "%s: quick test script '%s' ignored: doesn't exist\n" "$0" "$script_path" >&2
        return $FALSE
    fi

    printf "[INF] Running quick test script '%s' ...\n" "$script_path"
    sh "$script_path"

    return $TRUE
}

get_full_test_script_path()
{
    local test_group=$1
    local script_path="$(get_test_script_dir)/$(get_full_test_script_name $test_group)"
    echo $script_path
}

is_full_test_script_exist()
{
    local test_group=$1
    local script_path="$(get_full_test_script_path $test_group)"
    test -f "$script_path"
}

run_full_test()
{
    local test_group=$1
    local script_path="$(get_full_test_script_path $test_group)"
    if ! test -f "$script_path"; then
        printf "%s: full test script '%s' ignored: doesn't exist\n" "$0" "$script_path" >&2
        return $FALSE
    fi

    printf "[INF] Running full test script '%s' ...\n" "$script_path"
    sh "$script_path"

    return $TRUE
}

load_test_group()
{
    local i=$1
    local file=$2

    test_group_list[$i]=$(read_conf_item "group" "$file")
    if is_string_blank "${test_group_list[$i]}"; then
        printf "config item '%s' in config file '%s' is blank\n" "group" "$file"
        return $FALSE
    fi

    test_program_list[$i]=$(read_conf_item "program" "$file")
    if is_string_blank "${test_program_list[$i]}"; then
        printf "config item '%s' in config file '%s' is blank\n" "program" "$file"
        return $FALSE
    fi

    test_timeout_list[$i]=$(read_conf_item "timeout" "$file")
    src_data_git_list[$i]=$(read_conf_item "src_data_git" "$file")
    src_data_path_list[$i]=$(read_conf_item "src_data_path" "$file")
    des_data_path_list[$i]=$(read_conf_item "des_data_path" "$file")

    log_file_list[$i]=$(read_conf_item "log_file" "$file")

    printf "[INF] loaded test_group '%s' from file '%s'\n" "${test_group_list[$i]}" "$file"

    return $TRUE
}

load_all_test_group()
{
    printf "[INF] Loading all test_groups ...\n"

    local dir="$(get_test_group_conf_dir)"
    local i=0
    local file
    for file in $dir/test_group_*.conf; do
        if ! test -e $file; then
            continue
        fi

        if ! load_test_group $i "$file"; then
            return $FALSE
        fi

        i=$(expr $i + 1)
    done

    printf "[INF] %s test_groups loaded...\n" $i

    return $TRUE
}

is_valid_test_group()
{
    local target_group=$1

    local i
    for i in "${!test_group_list[@]}"
    do
        local test_group=${test_group_list[$i]}
        if test "$test_group" = "$target_group"; then
            return $TRUE
        fi
    done

    return $FALSE
}

get_des_data_path()
{
    local target_group=$1

    local i
    for i in "${!test_group_list[@]}"
    do
        local test_group=${test_group_list[$i]}
        if test "$test_group" = "$target_group"; then
            echo "${des_data_path_list[$i]}"
            return $TRUE
        fi
    done

    return $FALSE
}

detect_input_data_space_usage()
{
    local des_data_path=$1
    local cmd="du -s $des_data_path"
    local output
    if ! output=$(du -s "$des_data_path"); then
        printf "[ERR] '%s' failed with err %s \n" "$cmd" $? >&2
        return $FALSE
    fi

    local word
    for word in $output
    do
        if ! is_number "$word"; then
            printf "[ERR] unexpected output from '%s': '%s'\n" "$cmd" "$output" >&2
            return $FALSE
        else
            echo "$word"
            return $TRUE
        fi
    done
}

is_input_data_ready()
{
    local test_group=$1

    local des_data_path
    if ! des_data_path=$(get_des_data_path $test_group); then
       printf "[ERR] can't get des_data_path for test_group '%s'\n" "$test_group"
       return $FALSE
    fi

    if ! test -d "$des_data_path"; then
        printf "[ERR] des_data_path '%s' for test_group '%s' doesn't exist\n" "$des_data_path" "$test_group"
        return $FALSE
    fi

    local space_usage
    if ! space_usage=$(detect_input_data_space_usage "$des_data_path"); then
        return $FALSE
    fi

    printf "[INF] des_data_path: %s, space_usage: %s, space_usage_previous: %s\n" "$des_data_path" "$space_usage" "$input_data_space_usage"

    if test $space_usage -ne $input_data_space_usage; then
        # input data space usage is changed, clear detecting counter
        input_data_space_usage=$space_usage
        input_data_not_change_counter=0
    else
        # input data space usage isn't changed since last detecting, increase detecting counter
        input_data_not_change_counter=$(expr $input_data_not_change_counter + 1)
        if test $input_data_not_change_counter -ge $INPUT_DATA_NOT_CHANGE_MAX; then
            # input data is ready(input data space usage is not changed for 10 seconds)
            return $TRUE
        fi
    fi

    return $FALSE
}

retry()
{
    local interval=$1
    shift
    local max_retries=$1
    shift
    local cmd="$@"

    local i=0
    while test $max_retries -eq $RETRY_INFINITE -o $i -lt $max_retries
    do
        if $cmd; then
            return $TRUE
        fi

        sleep $interval
        i=$(expr $i + 1)
    done

    return $FALSE
}

wait_for_input_data()
{
    local test_group=$1

    input_data_space_usage=-1
    input_data_not_change_counter=0

    printf "[INF] %s: waiting for input data...\n" "$test_group"

    if ! retry $RETRY_INTERVAL $RETRY_INFINITE is_input_data_ready $test_group; then
        printf "[ERR] %s: waiting for input data timeout\n" "$test_group" >&2
        return $FALSE
    else
        printf "[INF] %s: input data is ready, input data size: %s * 1024 bytes\n" "$test_group" $input_data_space_usage
        return $TRUE
    fi
}

run_single_test()
{
    local test_group=$1

    if is_test_need_input_data $test_group; then
        if ! is_whitelist_enabled; then
            printf "[INF] test_group '%s' needs input data, ignored\n" "$test_group"
            return $TRUE
        fi

        if ! wait_for_input_data $test_group; then
            return $FALSE
        fi
    fi

    if is_whitelist_enabled; then
        if ! is_whitelist_hit "$test_group"; then
            run_quick_test $test_group
            return
        fi
    fi

    run_full_test $test_group
}

run_all_test()
{
    local i
    for i in "${!test_group_list[@]}"
    do
        local test_group=${test_group_list[$i]}

        run_single_test "$test_group"
    done
}

run_test_group()
{
    local test_group=$1

    if ! is_whitelist_enabled; then
        printf "%s: git project list missing while running test_group '%s'\n" $0 "$test_group" >&2
        return $FALSE
    fi

    if ! is_valid_test_group "$test_group"; then
        printf "%s: error: '%s' is not a valid test_group\n" $0 "$test_group" >&2
        return $FALSE
    fi

    if run_single_test "$test_group"; then
        return $TRUE
    else
        return $FALSE
    fi
}

main()
{
    local cmd_line="$@"
    if ! parse_cmd_line $cmd_line; then
        printf "%s: failed to parse command line: %s\n" $0 "$cmd_line" >&2
        show_usage
        exit $FALSE
    fi

    if ! load_all_test_group; then
        return $FALSE
    fi

    if test "$query_cmd"; then
        # -q test_seq
        if result=$(query_test_seq); then
            printf "$result\n"
            exit $TRUE
        else
            exit $FALSE
        fi
    elif test "$test_group_to_be_run"; then
        # -p <...> -g <test_group>
        if run_test_group "$test_group_to_be_run"; then
            exit $TRUE
        else
            exit $FALSE
        fi
    else
        run_all_test
    fi
}

main "$@"
