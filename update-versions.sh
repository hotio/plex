#!/bin/bash
set -exuo pipefail

version=$(curl -fsSL "https://plex.tv/api/downloads/5.json" | jq -re .computer.Linux.version)
json=$(cat meta.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    '.version = $version' <<< "${json}" | tee meta.json
