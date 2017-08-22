#!/usr/bin/env bash

server_script=$1

log_level='info'
if [ ! -z `$2` ]; then
    log_level=$2
fi

prefix=`echo ${server_script} | cut -d _ -f 1`

if [ $prefix == "hwa" ] || [ $prefix == "bwa" ]; then
    # mongo not required
    echo "Mongo is not required, move on.."
else
    echo "Starting mongo locally for ${server_script}"
    bash start_local_mongo.sh || exit 1
fi

${server_script} --data-dir ~/data --console-log-level ${log_level}
