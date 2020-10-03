[<img src="https://hotio.dev/img/plex.png" alt="logo" height="130" width="130">](https://www.plex.tv)

![Base](https://img.shields.io/badge/base-ubuntu-orange)
[![GitHub](https://img.shields.io/badge/source-github-lightgrey)](https://github.com/hotio/docker-plex)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/plex)](https://hub.docker.com/r/hotio/plex)
[![GitHub Registry](https://img.shields.io/badge/registry-ghcr.io-blue)](https://github.com/users/hotio/packages/container/package/plex)
[![Discord](https://img.shields.io/discord/610068305893523457?color=738ad6&label=discord&logo=discord&logoColor=white)](https://discord.gg/3SnkuKp)
[![Upstream](https://img.shields.io/badge/upstream-project-yellow)](https://www.plex.tv)

## Starting the container

Just the basics to get the container running:

```shell hl_lines="4 5 6 7 8 9 10 11 12 13"
docker run --rm \
    --name plex \
    -p 32400:32400 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=002 \
    -e TZ="Etc/UTC" \
    -e ARGS="" \
    -e DEBUG="no" \
    -e PLEX_CLAIM="" \
    -e ADVERTISE_IP="" \
    -e ALLOWED_NETWORKS="" \
    -e PLEX_PASS="no" \
    -v /<host_folder_config>:/config \
    -v /<host_folder_transcode>:/transcode \
    hotio/plex
```

The [highlighted](https://hotio.dev/containers/plex) variables are all optional, the values you see are the defaults. In most cases you'll need to add an additional volume (`-v`) or more, depending on your own personal preference, to get access to additional files.

When using the `autoscan` tag.

```shell hl_lines="4 5 6 7 8 9 10 11 12 13 14 15 16"
docker run --rm \
    --name plex-autoscan \
    -p 32400:32400 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=002 \
    -e TZ="Etc/UTC" \
    -e ARGS="" \
    -e DEBUG="no" \
    -e PLEX_CLAIM="" \
    -e ADVERTISE_IP="" \
    -e ALLOWED_NETWORKS="" \
    -e PLEX_PASS="no" \
    -e PLEXAUTOSCAN_ARGS="" \
    -e PLEX_LOGIN="" \
    -e PLEX_PASSWORD="" \
    -v /<host_folder_config>:/config \
    -v /<host_folder_transcode>:/transcode \
    hotio/plex:autoscan
```

If `PLEX_LOGIN` + `PLEX_PASSWORD` are not empty and the file `/config/plexautoscan/plex.token` does not exist, an attempt is made to get a Plex token for PlexAutoscan.

## Tags

| Tag                | Upstream                                                                     |
| -------------------|------------------------------------------------------------------------------|
| `release` (latest) | Releases                                                                     |
| `autoscan`         | Releases, including [Plex Autoscan](https://github.com/l3uddz/plex_autoscan) |

You can also find tags that reference a commit or version number.

## Volumes

By default the container has 2 volumes defined, the volume `/config` that contains the configuration files and the volume `/transcode` which is used as the default transcode directory.

## Claim your server

Go to [plex.tv/claim](https://www.plex.tv/claim) and login with your account, copy the claim code and add it to the environment variable like this `-e PLEX_CLAIM="claim-xxxxxxxxxxxxxxxxxxxx"`. When starting the new plex server for the first time, the server will be added to your account.

## Plex Pass

If you are a Plex Pass subscriber, you can enable the install of beta builds with `-e PLEX_PASS="yes"`. When the container starts, a version check is done for the latest beta and installed if a newer version is found.

## Configuration location

Your plex configuration inside the container is stored in `/config/app/Plex Media Server`, your `Preferences.xml` file its full path would be `/config/app/Plex Media Server/Preferences.xml`.

## Hardware support

To make your hardware devices available inside the container use the following argument `--device=/dev/dri:/dev/dri` for Intel QuickSync and `--device=/dev/dvb:/dev/dvb` for a tuner. NVIDIA users should go visit the [NVIDIA github](https://github.com/NVIDIA/nvidia-docker) page for instructions.

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```

## Troubleshooting a problem

By default all output is redirected to `/dev/null`, so you won't see anything from the application when using `docker logs`. Most applications write everything to a log file too. If you do want to see this output with `docker logs`, you can use `-e DEBUG="yes"` to enable this.
