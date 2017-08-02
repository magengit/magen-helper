#!/usr/bin/env bash

docker_compose_file_path=$1
service_name=$2
port=$3
magen_network_name='magen_net'
docker_mongo_name='magen_mongo'



if [ -n "$(docker network ls | grep ${magen_network_name})" ];
then
    echo "${magen_network_name} network is found... Continue..."
else
    echo "Creating magen_net network..."
    # Explicit driver assigning
    docker network create ${magen_network_name} --driver bridge
fi

if [ -z "$(docker ps -a -f "name=${docker_mongo_name}" -q)" ];
then
    echo "Launching ${docker_mongo_name} and ${service_name} containers"
    docker-compose -f ${docker_compose_file_path}  up -d
else
    echo "${docker_mongo_name} container detected. Launching ${service_name} container"
    docker-compose -f ${docker_compose_file_path} run --name ${service_name} -d -p ${port}:${port} ${service_name}
fi
