FROM ghcr.io/hotio/base@sha256:dd2e4e2d04e6a251ee3249d491ca1f198e0514bcd3d301faf01310d6cf9bfd65

ARG DEBIAN_FRONTEND="noninteractive"

ENV PLEX_CLAIM="" ADVERTISE_IP="" ALLOWED_NETWORKS="" PLEX_PASS="no"

EXPOSE 32400/tcp

VOLUME ["/transcode"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        xmlstarlet \
        beignet-opencl-icd \
        ocl-icd-libopencl1 && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG VERSION

# install app
RUN debfile="/tmp/plex.deb" && wget2 -nc -O "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_amd64.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${VERSION}" > "${APP_DIR}/version" && \
    mkdir "${APP_DIR}/config" && ln -s "${CONFIG_DIR}" "${APP_DIR}/config/Plex Media Server"

COPY root/ /
