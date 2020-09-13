FROM hotio/base@sha256:82db1fa1fa710414cb65f49f8447b0ba5802a9f10be237d42a5de181cc6768b5

ARG DEBIAN_FRONTEND="noninteractive"

ENV PLEX_CLAIM="" ADVERTISE_IP="" ALLOWED_NETWORKS="" PLEX_PASS="no"

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp

VOLUME ["/transcode"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        xmlstarlet && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG VERSION

# install app
RUN debfile="/tmp/plex.deb" && curl -fsSL -o "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_armhf.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${VERSION}" > "${APP_DIR}/version"

COPY root/ /
