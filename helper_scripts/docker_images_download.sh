#!/usr/bin/env bash
set -u
set -e
set -o pipefail

progname=$(basename $0)
prog_dir=$(dirname $0)
PATH=$PATH:${prog_dir}    # find various sub-utility scripts, in same directory

docker_registry=$1
docker_registry_login.sh $docker_registry || exit 1
docker_registry_type=$(docker_registry_type $docker_registry)

image_repos=(
    magen-id
    magen-ks
    magen-in
    magen-ps
    magen-hwa
)

for image_repo in ${image_repos[@]}; do
    if [ $docker_registry_type = amazon_ecr ]; then
        case $image_repo in
	magen-id)
	    image_repo=magen-id-opensource
	    ;;
	magen-in)
	    image_repo=magen-ingestion
	    ;;
	esac
    fi
    # will not re-pull if already present
    image_ref=$image_repo:latest
    echo "$progname: checking/pulling $image_ref"
    docker pull $docker_registry/$image_ref || exit 1
done
