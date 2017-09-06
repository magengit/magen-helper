#!/usr/bin/env bash
set -u

progname=$(basename $0)
prog_dir=$(dirname $0)
PATH=$PATH:${prog_dir}    # find various sub-utility scripts, in same directory

docker_registry=$1
op=$2

registry_type=$(docker_registry_type.sh $docker_registry)
case $op in
pull|push)
    ;;
*)
    exit 1
    ;;
esac

case $registry_type in
amazon_ecr)
    aws_login.sh || exit 1
    ;;
docker_hub)
    if [ $op = push ]; then # no login required for pull
        docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD" || exit 1
    fi
    ;;
*)
    exit 1
    ;;
esac
