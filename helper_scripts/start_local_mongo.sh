#!/usr/bin/env bash
#!/bin/bash

DATA_DIR="/data/db"
if [ "$(pgrep mongod)" == "" ]
then
    echo "************  STARTING LOCAL MONGO ************"
    mkdir -p ~/log

    if [ ! -d ${DATA_DIR} ]
    then
        sudo mkdir -p ${DATA_DIR}
        if [ $(uname) == "Darwin" ]
        then
            sudo chown -R `whoami` ${DATA_DIR}
        fi
    fi

    mongod --fork --logpath ~/log/mongodb.log
else
    echo "************ MONGO PID FOUND **************"
fi
