#!/bin/bash

version=$(curl -fsSL "https://plex.tv/api/downloads/5.json" | jq -r .computer.Linux.version)
[[ -z ${version} ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'"' <<< "${version_json}" > VERSION.json
