ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_ARM64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64}
EXPOSE 32400
VOLUME ["/transcode"]
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="32400/tcp,32400/udp" PLEX_CLAIM_TOKEN="" PLEX_ADVERTISE_URL="" PLEX_NO_AUTH_NETWORKS="" PLEX_BETA_INSTALL="false" PLEX_PURGE_CODECS="false"

RUN apk add --no-cache dpkg && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community xmlstarlet

# install plex
ARG VERSION
RUN debfile="/tmp/plex.deb" && \
    mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_arm64.deb" -o "${debfile}" && \
    dpkg-deb -x "${debfile}" "${APP_DIR}/bin" && \
    rm "${debfile}" && \
    echo "${VERSION}" > "${APP_DIR}/version" && \
    mkdir "${APP_DIR}/config" && \
    ln -s "${CONFIG_DIR}" "${APP_DIR}/config/Plex Media Server"

COPY root/ /
