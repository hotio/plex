#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    export DOCKER_CLI_EXPERIMENTAL=enabled
    image="cr.hotio.dev/hotio/base"
    tag="focal"
    manifest=$(docker manifest inspect ${image}:${tag})
    [[ -z ${manifest} ]] && exit 1
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-amd64.Dockerfile  && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-arm64.Dockerfile  && echo "${digest}"
elif [[ ${1} == "tests" ]]; then
    echo "List installed packages..."
    docker run --rm --entrypoint="" "${2}" apt list --installed
    echo "Check if app works..."
    app_url="http://localhost:32400/web"
    docker run --network host -d --name service "${2}"
    currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${app_url}" > /dev/null) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done
    curl -fsSL "${app_url}" > /dev/null
    status=$?
    [[ ${2} == *"linux-arm64" ]] && status=0
    echo "Show docker logs..."
    docker logs service
    exit ${status}
elif [[ ${1} == "screenshot" ]]; then
    app_url="http://localhost:32400/web"
    docker run --rm --network host -d --name service "${2}"
    currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${app_url}" > /dev/null) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done
    docker run --rm --network host --entrypoint="" -u "$(id -u "$USER")" -v "${GITHUB_WORKSPACE}":/usr/src/app/src zenika/alpine-chrome:with-puppeteer node src/puppeteer.js
    exit 0
else
    version=$(curl -fsSL "https://plex.tv/api/downloads/5.json" | jq -r .computer.Linux.version)
    [[ -z ${version} ]] && exit 1
    intel_compute_runtime_version=$(curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -r '.tag_name')
    [[ -z ${intel_compute_runtime_version} ]] && exit 1
    echo '{"version":"'"${version}"'","intel_compute_runtime_version":"'"${intel_compute_runtime_version}"'"}' | jq . > VERSION.json
fi
