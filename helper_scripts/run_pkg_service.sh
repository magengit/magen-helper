#!/usr/bin/env bash

server_script=$1
log_dir=$2

log_level='info'
if [ ! -z `$3` ]; then
    log_level=$3
fi

log_name='server.log'
if [ ! -z `$4` ]; then
    log_name=$4
fi

${server_script} --data-dir ~/data --console-log-level ${log_level} --log-dir ${log_dir} 2>&1 >> ${log_name}
