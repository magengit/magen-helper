#!/usr/bin/env bash
set -u

# can a simple "docker-compose up" be used?
#
# return 0 if can run docker-compose up to run all containers in yml file.
#          (mongo not needed, or needed and not running)
# return 1 if must supply additional parameters to start service but not mongo
#          (mongo needed but already running)
# Side effects:
# - generate logging output for operation that will be done by caller
docker_compose_run_simple_check()
{
    service=$1
    case $service in
    magen_hwa|magen_bwa)
        # mongo not required
	echo "Launching $service container."
	return 0
	;;
    esac
    if [ -z "$(docker ps -a -f "name=magen_mongo" -q)" ]; then
	echo "Launching $service and Mongo containers"
	return 0
    fi
    echo "Launching $service container. (Mongo container already running)"
    return 1
}

###
### MAIN
###

progname=$(basename $0)
script_dir=$(dirname $0)
PATH=$script_dir:$PATH

# arguments (mandatory/order-specific)
if [ $# -lt 1 ]; then
    echo "$progname: FATAL: unexpected argument" >&2
    exit 1
fi

docker_compose_fpath=$1
magen_network_name=${2:-magen_net}
docker_registry=$3

case $docker_compose_fpath in
*.yml)
    # okay
    ;;
*)
    echo "$progname: FATAL: unexpected argument ($1)" >&2
    exit 1
    ;;
esac

if [ -z "$(docker network ls | grep ${magen_network_name})" ]; then
    echo "Docker Network ${magen_network_name} being created."
    # Explicit driver assigning
    docker network create ${magen_network_name} --driver bridge
else
    echo "Docker Network ${magen_network_name} exists, continuing."
fi

# launch  microservice and magen_mongo containers as needed
docker_registry_login.sh $docker_registry pull || exit 1

docker-compose -f ${docker_compose_fpath}  up -d
