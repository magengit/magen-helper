#!/usr/bin/env bash

server_script=$1

log_level='info'
if [ ! -z `$2` ]; then
    log_level=$2
fi

start_local_mongo.sh || exit 1

${server_script} --data-dir ~/data --console-log-level ${log_level}
