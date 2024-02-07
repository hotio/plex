#!/bin/bash
set -e
version=$(curl -fsSL "https://plex.tv/api/downloads/5.json" | jq -re .computer.Linux.version)
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    '.version = $version' <<< "${json}" | tee VERSION.json
