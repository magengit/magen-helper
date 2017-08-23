#!/usr/bin/env bash
set -u

if [ -n "$(docker ps -a | grep Exit)" ]
then
    docker ps -a | grep Exit | awk '{print $1}' | xargs docker rm > /dev/null
fi
echo "Killed Containers removed"

if [ -n "$(docker images -q --filter "dangling=true")" ]
then
    docker rmi $(docker images | grep "<none>" | awk '{print $3}') > /dev/null
    image_str="Unused Images removed..."
else
    image_str="No Unused Images to remove..."
fi
echo "$image_str [Note: To remove _all_ images, run 'make rm_docker']"

if [ -n "$(docker volume ls -qf dangling=true)" ]
then
    docker volume rm $(docker volume ls -qf dangling=true) > /dev/null
fi
echo "Volumes are clean"
