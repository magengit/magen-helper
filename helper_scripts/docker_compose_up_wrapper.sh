#!/usr/bin/env bash
set -u

# Set environment variables for "docker-compose up", based on env file that may
# or may not be present.
# (Could be simpler with docker-compose 1.15 and up:
#  - env file may be passed as argument to docker-compose, vs can only be
#    in docker-compose file so cannot be optional
#  - current scheme requires that docker-compose file lists all the variables
#    that might be present in the env file


#
# Is this run of "docker up" for production (prod) or test
#
docker_exec_type_get()
{
    docker_exec_type=prod # default (no docker file case) is production

    docker_compose_file=
    while [ $# != 0 ]; do
	case $1 in
	-f)
            shift
            docker_compose_file=${1:-}
	    ;;
	*)
	    ;;
	esac
        shift
    done
    if [ "$docker_compose_file" != "${docker_compose_file/test/}" ]; then
        docker_exec_type=test
    fi
    echo $docker_exec_type
}

#
# MAIN
#
progname=$(basename $0)

# production or test
docker_exec_type=$(docker_exec_type_get ${1+"$@"})

# if docker file exists, export its variables, which should be matched
# by env statements (with no values) in docker-compose file.
docker_env_file=../data/secrets/docker_env_$docker_exec_type.txt
if [ -f $docker_env_file ]; then
    echo "$progname: ENV file ($docker_env_file) being sourced"
    set -a # env variables should be exported to docker-compose
    source $docker_env_file
    set +a
else
    echo "$progname: ENV file ($docker_env_file) not present"
fi

# environment, if any, is set: run docker-compose passing all arguments
docker-compose ${1+"$@"}