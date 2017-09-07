#!/usr/bin/env bash
set -u
CURL=curl

# DEBUG: enable below  a) no var undef errs, b) show curl rather than do
# set +u; CURL="echo $(basename $0): TRIGGER ARGS: $CURL"

#
# Body of request to trigger dependent builds.
# - Trigger same build as ours (native for native, docker for docker)
# - Pass an extra env variable so triggered build knows both that
#   it was triggered and by which repo's commit
# - Travis is a bit fussy about the format of the env section,
#   which is split across multiple lines below for readability but
#   must be presented to travis as a single line (even with the "" around
#   all the env variables), thus the use of backslashes.
travis_body()
{
    message="Triggered $TO_BUILD build: by $TRAVIS_REPO_SLUG commit $TRAVIS_COMMIT"

cat <<TRAVIS_BODY
{
    "request": {
        "message": "$message",
        "branch": "master",
        "config": {
            "matrix": {
                "include": {
                    "env": \
"TO_BUILD=$TO_BUILD \
 MAGEN_TRIGGER_REPO_SLUG=$TRAVIS_REPO_SLUG",
                     "python": "3.6"
                }
            }
        }
    }
}
TRAVIS_BODY
}

progname=$(basename $0)
prog_dir=`dirname $0`
PATH=$PATH:${prog_dir}    # find various sub-utility scripts, in same directory

organization=$(workspace_info.sh --op organization)
if [ -z "$organization" ]; then
    echo "$progname: ERROR: organization (repo cluster) not set"
    exit 1
fi
repo_under_test=$(workspace_info.sh --op repository)
if [ -z "$repo_under_test" ]; then
    echo "$progname: ERROR: repo_under_test not set"
    exit 1
fi

echo "y" | travis login --org --github-token  $GITHUB_TOKEN

request_body="$(travis_body)"
echo "$progname: BODY: $request_body"

declare -a repo_list
repo_tags=(core ks ingestion id ps hwa)

case $organization in
magengit)
    travis_svc=travis-ci.org
    repo_tags=("${repo_tags[@]/ingestion/in}")
    ;;
Cisco-Magen)
    travis_svc=travis-ci.com
    repo_tags=("${repo_tags[@]}" id-open-source bwa)
    ;;
*)
    echo "$progname: ERROR: uknown organization ($organization)"
    exit 1
    ;;
esac

# walk through the dependent repos, triggering testing
for repo_tag in ${repo_tags[@]}; do
    if [ $repo_tag = core -a "$repo_under_test" != magen-helper ]; then
	continue # be sure not to trigger magen-core from magen-core
    fi
    repo=magen-$repo_tag

    # %@F is to make $repo/requests one level in url hierarchy
    repo_url=https://api.$travis_svc/repo/$organization%2F$repo/requests
    echo "$progname: TRIGGERING $repo_url"

    $CURL -s -X POST \
	 -H "Content-Type: application/json" \
	 -H "Accept: application/json" \
	 -H "Travis-API-Version: 3" \
	 -H "Authorization: token ${TRAVIS_AUTH_TOKEN}" \
	 -d "$request_body" \
	 $repo_url
done
