#!/usr/bin/env bash

if [ "$(docker ps -a | grep Exit)" != "" ]
then
    docker ps -a | grep Exit | awk '{print $1}' | xargs docker rm > /dev/null
fi
echo "Killed Containers removed"

if [ "$(docker images -q --filter "dangling=true")" != "" ]
then
    echo "Removing Unused Images"
    docker rmi $(docker images | grep "<none>" | awk '{print $3}') > /dev/null
else
    echo "No Unused Images. Run 'make rm_docker' to remove all images"
fi

if [ "$(docker volume ls -qf dangling=true)" != "" ]
then
    docker volume rm $(docker volume ls -qf dangling=true) > /dev/null
fi
echo "Volumes are clean"
