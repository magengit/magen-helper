#!/usr/bin/env bash

progname=$(basename $0)

usage()
{
    cat <<USAGE
Usage: $progname path_to_docker_compose_file container_name port

Description:
	Run docker container and required links
USAGE

    exit $1
}

# return 0 if can run docker-compose up to run all containers in yml file.
#          (mongo not needed, or needed and not running)
# return 1 if must supply additional parameters to start service but not mongo
#          (mongo needed but already running)
# Side effects:
# - generate logging output for operation that will be done by caller
docker_compose_run_simple_check()
{
    service=$1
    case ${service} in
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

# arguments (mandatory/order-specific)
docker_compose_file_path=$1
service_name=$2
port=$3
magen_network_name='magen_net'
docker_mongo_name='magen_mongo'

if [ -z "$service_name" ] || [ -z "$port" ]; then
    echo "Container [name] and [port] are required arguments"
    usage 1;
fi

###
### MAIN
###

if [ -z "$(docker network ls | grep ${magen_network_name})" ]; then
    echo "Docker Network ${magen_network_name} being created."
    # Explicit driver assigning
    docker network create ${magen_network_name} --driver bridge
else
    echo "Docker Network ${magen_network_name} exists, continuing."
fi

# launch  microservice and magen_mongo containers as needed
if docker_compose_run_simple_check ${service_name}; then
    docker-compose -f ${docker_compose_file_path}  up -d
else
    # - magen_mongo may already have been started (e.g. for another service)
    #   in which case only start the microservice container
    #   - Note: docker-compose complains of conflict if existing magen_mongo was
    #           started on behalf of another service (though _not_,
    #           interestingly, if previously started on behalf of this service).
    docker-compose -f ${docker_compose_file_path} run --name ${service_name} -d -p ${port}:${port} ${service_name}
fi
