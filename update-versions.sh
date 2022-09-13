#!/bin/bash

version=$(curl -fsSL "https://plex.tv/api/downloads/5.json" | jq -r .computer.Linux.version)
[[ -z ${version} ]] && exit 0
intel_compute_runtime_version=$(curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -r '.tag_name')
[[ -z ${intel_compute_runtime_version} ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .intel_compute_runtime_version = "'"${intel_compute_runtime_version}"'"' <<< "${version_json}" > VERSION.json
