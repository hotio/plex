ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 32400
ARG DEBIAN_FRONTEND="noninteractive"

ENV PLEX_CLAIM="" ADVERTISE_IP="" ALLOWED_NETWORKS="" PLEX_PASS="no"

VOLUME ["${CONFIG_DIR}","/transcode"]

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

# install plex
ARG VERSION
RUN debfile="/tmp/plex.deb" && wget2 -nc -O "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_amd64.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${VERSION}" > "${APP_DIR}/version" && \
    mkdir "${APP_DIR}/config" && ln -s "${CONFIG_DIR}" "${APP_DIR}/config/Plex Media Server"

COPY root/ /
RUN chmod -R +x /etc/cont-init.d/ /etc/services.d/
