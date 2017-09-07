#!/usr/bin/env bash
# look up repo, organization, or registry from git workspace
# If nested repos, find the highest repo, so look all the way to '/'
set -u

progname=$(basename $0)

op=
while [ $# != 0 ]; do
    case $1 in
    --op)
        shift
	op=$1
        ;;
    *)
        echo "$progname: ERROR: unknown argument $1" >&2
	exit 1
	;;
    esac
    shift
done

case $op in
repository|organization|registry)
    ;;
"")
    echo "$progname: ERROR: operation unspecifiedc" >&2
    exit 1
    ;;
*)
    echo "$progname: ERROR: unknown operation ($op)" >&2
    exit 1
    ;;
esac

git_origin_get()
{
    repo_root=$1
    (cd $repo_root;
     if [ $? != 0 ]; then
	 return 1
     fi
     git_origin=$(git remote get-url origin)
     if [ $? != 0 ]; then
	 return 1
     fi
     echo $git_origin)
}

git_slug_get()
{
    git_origin=$(git_origin_get $repo_root)
    if [ $? != 0 ]; then
	return 1
    fi
    repo=$(basename $git_origin .git)
    if [ -z "$repo" ]; then
	return 1
    fi
    organization=$(basename $(dirname $git_origin) | sed -e 's/.*://')
    if [ -z "$organization" ]; then
	return 1
    fi
    echo $organization/$repo
}

repo_root=

path=$(pwd)
while true; do
    if [ -d $path/.git ]; then
	repo_root=$path
    fi
    path=`dirname $path`
    if [ "$path" = '/' -o "$path" = "" ]; then
	break
    fi
done

if [ -z "$repo_root" ]; then
    exit 1
fi
git_slug=$(git_slug_get $repo_root)
if [ $? != 0 ]; then
    exit 1
fi
repository=$(basename $git_slug)
organization=$(dirname $git_slug)

case $op in
repository)
    echo $repository
    ;;
organization)
    echo $organization
    ;;
registry)
    case $organization in
    magengit)
        docker_registry=magendocker
	;;
    Cisco-Magen)
	docker_registry=079349112641.dkr.ecr.us-west-2.amazonaws.com
	;;
    *)
        exit 1
        ;;
    esac
    echo $docker_registry
    ;;
esac
