FROM ghcr.io/hotio/base@sha256:cef93cdc825facca1f6b2eebe95b9f4e4bad4c953407f5afa435d4eb23297fd1

ARG DEBIAN_FRONTEND="noninteractive"

ENV PLEX_CLAIM="" ADVERTISE_IP="" ALLOWED_NETWORKS="" PLEX_PASS="no"

EXPOSE 32400/tcp

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
RUN debfile="/tmp/plex.deb" && wget2 -nc -O "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_armhf.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${VERSION}" > "${APP_DIR}/version"

COPY root/ /
