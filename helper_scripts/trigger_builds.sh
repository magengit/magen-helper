#!/usr/bin/env bash


#config="{
#   \"env\": {
#     "$build"
#   },
#   \"python\": \"3.6\"
#  }"

#config="{
#     \"matrix\": [\"env\": \"$build\", \"python\": \"3.6\"]
#  }"


echo "y" | travis login --pro --github-token  $GIT_HUB_TOKEN

message="Magen-core commit: "$TRAVIS_COMMIT", job: $TO_BUILD, triggering build"
build="TO_BUILD=$TO_BUILD"

config="{
     \"matrix\": {\"include\": {\"env\": \"$build\", \"python\": \"3.6\"}}
  }"

echo $config

body="{
 \"request\": {
 \"message\": \""$message"\",
 \"branch\":\"master\",
 \"config\": "$config"
}}"

echo $body

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token FZgO32qBc94VVpf2hJdWUQ" \
 -d "$body" \
 https://api.travis-ci.com/repo/Cisco-Magen%2Fmagen-ps/requests

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token FZgO32qBc94VVpf2hJdWUQ" \
 -d "$body" \
 https://api.travis-ci.com/repo/Cisco-Magen%2Fmagen-ks/requests

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token FZgO32qBc94VVpf2hJdWUQ" \
 -d "$body" \
 https://api.travis-ci.com/repo/Cisco-Magen%2Fmagen-ingestion/requests

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token FZgO32qBc94VVpf2hJdWUQ" \
 -d "$body" \
 https://api.travis-ci.com/repo/Cisco-Magen%2Fmagen-id/requests

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token FZgO32qBc94VVpf2hJdWUQ" \
 -d "$body" \
 https://api.travis-ci.com/repo/Cisco-Magen%2Fmagen-id-open-source/requests

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token FZgO32qBc94VVpf2hJdWUQ" \
 -d "$body" \
 https://api.travis-ci.com/repo/Cisco-Magen%2Fmagen-hwa/requests

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token FZgO32qBc94VVpf2hJdWUQ" \
 -d "$body" \
 https://api.travis-ci.com/repo/Cisco-Magen%2Fmagen-bwa/requests