ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 32400
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="32400/tcp" PLEX_CLAIM_TOKEN="" PLEX_ADVERTISE_URL="" PLEX_NO_AUTH_NETWORKS="" PLEX_BETA_INSTALL="false" PLEX_PURGE_CODECS="false"

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        xmlstarlet && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install plex
ARG VERSION
RUN debfile="/tmp/plex.deb" && \
    mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_amd64.deb" -o "${debfile}" && \
    dpkg-deb -x "${debfile}" "${APP_DIR}/bin" && \
    rm "${debfile}" && \
    echo "${VERSION}" > "${APP_DIR}/version" && \
    mkdir "${APP_DIR}/config" && \
    ln -s "${CONFIG_DIR}" "${APP_DIR}/config/Plex Media Server"

COPY root/ /
RUN find /etc/s6-overlay/s6-rc.d -name "run*" -execdir chmod +x {} +
