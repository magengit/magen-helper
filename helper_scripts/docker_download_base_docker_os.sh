#!/usr/bin/env bash
set -u
set -ev
set -o pipefail

prog_dir=`dirname $0`
PATH=$PATH:${prog_dir}    # find various sub-utilities, e.g. aws_login.sh

docker_compose_check.sh || exit 1

# aws_login.sh || exit 1

docker pull magendocker/magen-core:latest # pulling docker magen-core image
