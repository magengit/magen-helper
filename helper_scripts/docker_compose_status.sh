#!/usr/bin/env bash
set -u

# Post-processing step to Retrieve exit status from docker-compose execution
# (docker-compose {up | run}.
# Args:
# - docker-compose file, to know what containers should be examined
#
# NOTE: This is mitigation for the fact that docker-compose does not pass
#       through errors from the composed dockers. Consequence, for instance
#       is that travis-ci builds generate false success results on errors
#       This script can perhaps be replaced by running the
#       docker-compose execution with --exit-code-from <primarycontainer>
#       though this script exits an error on non-zero exit from any container.

progname=$(basename $0)
if [ $# -ne 1 ]; then
    echo "$progname: ERROR: docker-compose file not provided" >&2
    exit 1
fi
docker_compose_file=$1

exit_status=0 # assume no errors
for container in $(docker-compose -f ${docker_compose_file} ps -q); do
    container_status=$(docker inspect -f '{{ .State.ExitCode }}' ${container})
    container_status=${container_status:-1} # assume 1 if not found
    if [ ${container_status} != 0 ]; then
        container_name=$(docker inspect -f '{{ .Name }}' ${container})
        echo "$progname: ERROR: container ${container_name} exited ${container_status}" >&2
	if [ ${container_status} -gt ${exit_status} ]; then
	    exit_status=${container_status}
	fi
    fi
done
exit ${exit_status}
