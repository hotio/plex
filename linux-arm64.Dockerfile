FROM hotio/base

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        udev unrar && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG PLEX_VERSION=1.18.2.2058-e67a4e892

# install app
RUN debfile="/tmp/plex.deb" && curl -fsSL -o "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${PLEX_VERSION}/debian/plexmediaserver_${PLEX_VERSION}_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
