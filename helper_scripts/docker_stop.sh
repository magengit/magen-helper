#!/usr/bin/env bash

if [ ! -z "$(docker ps -a -q)" ]
then
    echo "Stopping All Running Containers"
    docker stop $(docker ps -a -q) > /dev/null
    echo "Removing Killed Containers"
    docker rm $(docker ps -a -q) > /dev/null
fi

