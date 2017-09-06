#!/usr/bin/env bash
set -u

progname=$(basename $0)

rmi_options=
image_pattern=
docker_network=
while [ $# != 0 ]; do
    case $1 in
    -images)
	shift
	image_pattern=$1
        ;;
    -net)
	shift
	docker_network=$1
	;;
    -f)
	rmi_options=$1
        ;;
    *)
	echo "$progname: unrecognized argument ($1)" >&2
	exit 1
	;;
    esac
    shift
done

if [ -z "$image_pattern" ]; then
    echo "$progname: must specify images argument" >&2
    exit 1
fi

images=$(docker images | grep -v ^REPOSITORY | grep "$image_pattern" | awk '{printf $3 " "}' | sort | uniq)
if [ -n "$images" ]; then
    echo "Removing Images Matching $image_pattern"
    docker rmi $rmi_options $images > /dev/null
fi
if [ -n "$(docker volume ls -qf dangling=true)" ]; then
    echo "Clearing All Volumes"
    docker volume rm $(docker volume ls -qf dangling=true) > /dev/null
fi
if [ -n "$docker_network" ]; then
    if [ -n "$(docker network ls | grep ${docker_network})" ]; then
        echo "Removing $docker_network network"
        docker network rm ${docker_network} > /dev/null
    fi
fi
