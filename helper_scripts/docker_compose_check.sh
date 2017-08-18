#!/usr/bin/env bash
set -u
set -ev
set -o pipefail

docker_compose_v=`docker-compose -v | awk -F "," '{ print $1 }' | awk '{ print $3 }' | awk -F "." '{ print $1 $2 }'`

if [ -z `which docker-compose` ] || [ ${docker_compose_v} -lt 110 ]; then
    echo "==== docker-compose is not installed ===="
    echo "try:"
    echo "  https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04"
    echo
    exit 127
fi
