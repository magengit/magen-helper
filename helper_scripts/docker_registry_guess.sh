#!/usr/bin/env bash
# look up path for git repo root.
# If nested repos, find the highest repo, so look all the way to '/'
# The need for this is a hack. 
# Eventually, this should not be needed and this case should be deleted.
set -u

progname=$(basename $0)

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
git_origin=$(git_origin_get $repo_root)
if [ $? != 0 ]; then
    exit 1
fi

if [ ${git_origin/magengit/} != $git_origin ]; then
    docker_registry=magendocker
elif [ ${git_origin/Cisco-Magen/} != $git_origin ]; then
    docker_registry=079349112641.dkr.ecr.us-west-2.amazonaws.com
else
    return 1
fi
echo $docker_registry
