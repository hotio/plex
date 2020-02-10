FROM hotio/dotnetcore@sha256:4645191ffe8a667b175c92738f81646ae8575ad2b6d61338825c24fbe5bbf4a5

ARG DEBIAN_FRONTEND="noninteractive"

ENV PLEX_CLAIM="" ADVERTISE_IP="" ALLOWED_NETWORKS="" PLEX_PASS="no"

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp

VOLUME ["/transcode"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        xmlstarlet uuid-runtime && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG PLEX_VERSION=1.18.6.2368-97add474d

# install app
RUN debfile="/tmp/plex.deb" && curl -fsSL -o "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${PLEX_VERSION}/debian/plexmediaserver_${PLEX_VERSION}_arm64.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${PLEX_VERSION}" > "${APP_DIR}/version"

COPY root/ /
