#!/usr/bin/env bash
# Find registry type from supplied registry
# As a hack, if no registry is supplied, try to dynamically
# determine registry based on current git workspace.
# Eventually, this should not be needed and this case should be deleted.
set -u

progname=$(basename $0)
prog_dir=$(dirname $0)
PATH=$PATH:${prog_dir}    # find various sub-utility scripts, in same directory

docker_registry=
case $# in
0)
    docker_registry=$(workspace_info.sh --op registry)
    ;;
1)
    docker_registry=$1
    ;;
*)
    echo "$progname: FATAL ERROR: unknown arguments (${1+$@})" >&2
    exit 1
    ;;
esac

if [ -z "$docker_registry" ]; then
    echo "$progname: FATAL ERROR: unable to determine docker registry" >&2
    exit 1
fi
if [ ${docker_registry/amazonaws/} != $docker_registry ]; then
    registry_type=amazon_ecr
else
    registry_type=docker_hub
fi
echo $registry_type
