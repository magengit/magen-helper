#!/usr/bin/env bash
set -u
set -ev
set -o pipefail

progname=$(basename $0)
prog_dir=`dirname $0`
PATH=$PATH:${prog_dir}    # find various sub-utility scripts, in same directory

# per-service state
DOCKER_SRC_TAG=$1 # docker image + tag, ex.: magen_ks:v1.3
DOCKER_IMAGE=$2 # docker image name, ex.: magen-ks
docker_registry=$(docker_registry_guess.sh) # hack
if [ -z "$docker_registry" ]; then
    echo "$progname: FATAL ERROR: docker registry not specified"
    exit 1
fi
docker_registry_type=$(docker_registry_type.sh $docker_registry)

TO_BUILD=${TO_BUILD:-Unset}
if [ "$TO_BUILD" = "NATIVE" ]; then
    case $docker_registry_type in
    amazon_ecr)
	python3 setup.py bdist_wheel upload -r jfrog || exit 1;
        ;;
    docker_hub)
	twine upload --username "$PYPI_USERNAME" --password  "$PYPI_PASSWORD" dist/*
	;;
    *)
	echo "$progname: FATAL ERROR: Unsupported registry type: $docker_registry_type"
	exit 1
	;;
    esac
elif [ "$TO_BUILD" = "DOCKER" ]; then
    docker_registry_login.sh "$docker_registry" push || exit 1
    docker tag ${DOCKER_SRC_TAG} $docker_registry/${DOCKER_IMAGE}:latest
    docker push $docker_registry/${DOCKER_IMAGE}:latest || exit 1
else
    echo "$progname: $TO_BUILD: Unsupported build"
    exit 1
fi
