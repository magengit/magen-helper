#!/usr/bin/env bash
set -u

docker_magen_mongo="magen_mongo"

if [ "$(docker ps -a -f "name=${docker_magen_mongo}" -q)" == "" ]
then
    echo "Looking for Local Mongo activity..."
    pkill mongod
    echo "Mongo is Cleaned up"
fi

