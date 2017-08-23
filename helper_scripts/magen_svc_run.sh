#!/usr/bin/env bash
set -u

server_script=$1

magen_helper_path=$2

log_level='info'
if [ ! -z `$3` ]; then
    log_level=$3
fi

helper_path=`cd ${magen_helper_path}/helper_scripts && pwd`

prefix=`echo ${server_script} | cut -d _ -f 1`

if [ ${prefix} == "hwa" ] || [ ${prefix} == "bwa" ]; then
    # mongo not required
    echo "Mongo is not required, move on.."
else
    echo "Starting mongo locally for ${server_script}"
    bash ${helper_path}/mongo_local_start.sh || exit 1
fi

case $prefix in
policy)
    ${server_script}
    ;;
*)
    ${server_script} --data-dir ~/magen_data --console-log-level ${log_level}
    ;;
esac
