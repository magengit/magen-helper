#!/usr/bin/env bash
set -u
set -ev
set -o pipefail

prog_dir=`dirname $0`
PATH=$PATH:${prog_dir}    # find various sub-utilities, e.g. aws_login.sh

# per-service state
DOCKER_SRC_TAG=$1 # docker image + tag, ex.: magen_ks:v1.3
DOCKER_IMAGE=$2 # docker image name, ex.: magen-ks

TO_BUILD=${TO_BUILD:-Unset}
if [ "$TO_BUILD" = "NATIVE" ]; then
    python3 setup.py bdist_wheel upload -r jfrog || exit 1;
elif [ "$TO_BUILD" = "DOCKER" ]; then
    aws_login.sh || exit 1
    docker tag ${DOCKER_SRC_TAG} 079349112641.dkr.ecr.us-west-2.amazonaws.com/${DOCKER_IMAGE}:latest
    docker push 079349112641.dkr.ecr.us-west-2.amazonaws.com/${DOCKER_IMAGE}:latest || exit 1
else
    echo "$TO_BUILD: Unsupported build"
    exit 1
fi
