#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    mkdir ~/.docker && echo '{"experimental": "enabled"}' > ~/.docker/config.json
    image="hotio/base"
    tag="bionic"
    manifest=$(docker manifest inspect ${image}:${tag})
    [[ -z ${manifest} ]] && exit 1
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-amd64.Dockerfile  && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm" and .platform.os == "linux").digest')   && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-arm-v7.Dockerfile && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-arm64.Dockerfile  && echo "${digest}"
else
    version=$(curl -fsSL "https://plex.tv/api/downloads/5.json" | jq -r .computer.Linux.version)
    [[ -z ${version} ]] && exit 1
    version_plexautoscan=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/l3uddz/plex_autoscan/commits/master" | jq -r .sha)
    [[ -z ${version_plexautoscan} ]] && exit 1
    version_rclone=$(curl -fsSL "https://downloads.rclone.org/version.txt" | sed s/rclone\ v//g)
    [[ -z ${version_rclone} ]] && exit 1
    sed -i "s/{PLEX_VERSION=[^}]*}/{PLEX_VERSION=${version}}/g" .github/workflows/build.yml
    sed -i "s/{PLEXAUTOSCAN_VERSION=[^}]*}/{PLEXAUTOSCAN_VERSION=${version_plexautoscan}}/g" .github/workflows/build.yml
    sed -i "s/{RCLONE_VERSION=[^}]*}/{RCLONE_VERSION=${version_rclone}}/g" .github/workflows/build.yml
    version="${version}/${version_plexautoscan}/${version_rclone}"
    echo "##[set-output name=version;]${version}"
fi
