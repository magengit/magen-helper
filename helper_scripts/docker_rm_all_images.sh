#!/usr/bin/env bash
set -u

magen_network_name='magen_net'

images=$(docker images -q | sort | uniq)
if [ -n "$images" ]; then
    echo "Removing All Images"
    docker rmi -f $(docker images -q) > /dev/null
fi
if [ -n "$(docker volume ls -qf dangling=true)" ]; then
    echo "Clearing All Volumes"
    docker volume rm $(docker volume ls -qf dangling=true) > /dev/null
fi
if [ -n "$(docker network ls | grep ${magen_network_name})" ]; then
    echo "Removing magen_net network"
    docker network rm ${magen_network_name} > /dev/null
fi
