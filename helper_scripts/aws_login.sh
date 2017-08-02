#! /usr/bin/env bash
set -u
set -e
set -o pipefail

progname=$(basename $0)
echo "$progname: get aws access credentials using aws cli (packaged as docker image)"

# need AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY envvars
if [ -z "${AWS_ACCESS_KEY_ID:-}" -o -z "${AWS_SECRET_ACCESS_KEY:-}" ]; then
    if [ -z "${AWS_ACCESS_KEY_ID:-}" ]; then
	echo "AWS_ACCESS_KEY_ID var is not set"
    fi
    if [ -z "${AWS_SECRET_ACCESS_KEY:-}" ]; then
	echo "AWS_SECRET_ACCESS_KEY is not set"
    fi
    exit 127
fi

aws_cli="docker run -i -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} pebbletech/docker-aws-cli aws"

docker --version
docker pull pebbletech/docker-aws-cli # pulling docker version of aws-cli

# removing deprecated -e flag from docker login command
docker_login=`${aws_cli} ecr get-login --region us-west-2 | awk -F "-e none" '{ print $1 $2 }'`

${docker_login} # docker login to AWS

