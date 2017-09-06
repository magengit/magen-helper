#!/usr/bin/env bash
set -u
set -e
set -o pipefail

prog_dir=`dirname $0`
PATH=$PATH:${prog_dir}    # find various sub-utility scripts, in same directory

docker_compose_check.sh || exit 1

docker_registry=$(docker_registry_guess.sh) # hack

docker_registry_login.sh $docker_registry pull || exit 1

docker pull $docker_registry/magen-core:latest # pulling docker magen-core image
