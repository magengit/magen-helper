#!/usr/bin/env bash
set -u

server_script=$1

magen_helper_path=$2

log_level=${3:-}

if [ -z "$log_level" ]; then
    log_level='info'
fi

helper_path=$(cd ${magen_helper_path}/helper_scripts && pwd)

prefix=$(echo ${server_script} | cut -d _ -f 1)
if [ "${prefix/policy/}" != $prefix ]; then
    prefix=ps
fi

case $prefix in
hwa|bwa)
    # mongo not required
    echo "Mongo is not required, move on.."
    ;;
*)
    echo "Starting mongo locally for ${server_script}"
    bash ${helper_path}/mongo_local_start.sh || exit 1
    ;;
esac

svc_root=~/magen_data/$prefix
data_dir=$svc_root/data
log_dir=$svc_root/logs
case $prefix in
*) # currently no special cases
    ${server_script} \
        --data-dir $data_dir            \
	--log-dir $log_dir              \
        --console-log-level $log_level
    ;;
esac
