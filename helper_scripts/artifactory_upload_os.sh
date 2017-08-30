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
# if [ "$TO_BUILD" = "NATIVE" ]; then
#     python3 setup.py bdist_wheel upload -r jfrog || exit 1;
if [ "$TO_BUILD" = "DOCKER" ]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD" || exit 1
    docker tag ${DOCKER_SRC_TAG} magendocker/${DOCKER_IMAGE}:latest
    docker push magendocker/${DOCKER_IMAGE}:latest || exit 1
else
    echo "$TO_BUILD: Unsupported build"
    exit 1
fi
