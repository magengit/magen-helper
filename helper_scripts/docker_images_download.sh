#!/usr/bin/env bash
set -u
set -e
set -o pipefail

progname=$(basename $0)
prog_dir=$(dirname $0)
PATH=$PATH:$prog_dir    # find various sub-utilities, e.g. aws_login.sh

docker_image_server=$1

if [ ${docker_image_server/amazonaws/} != $docker_image_server ]; then
   is_amazon_ec=true
else
   is_amazon_ec=false
fi

if [ $is_amazon_ec = true ]; then
    aws_login.sh || exit 1
fi

image_repos=(
    magen-id
    magen-ks
    magen-ingestion
    magen-ps
    magen-hwa
)

for image_repo in ${image_repos[@]}; do
    if [ $is_amazon_ec = true ]; then
        case $image_repo in
	magen-id)
	    image_repo=${image_repo}-opensource
	    ;;
	esac
    fi
    # will not re-pull if already present
    image_ref=$image_repo:latest
    echo "$progname: checking/pulling $image_ref"
    docker pull $docker_image_server/$image_ref || exit 1
done
