FROM cr.hotio.dev/hotio/base@sha256:cf8e30c733cd4f752bc02bfc991e3de33489c175da5b3710ab53ac4d56ab0c36

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

# install intel compute runtime
ARG INTEL_COMPUTE_RUNTIME_VERSION
RUN INTEL_URLS=$(curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/tags/${INTEL_COMPUTE_RUNTIME_VERSION}" | jq -r '.body' | grep wget | sed 's|wget ||g') && \
    mkdir -p /intel && \
    for i in ${INTEL_URLS}; do \
        i=$(echo ${i} | tr -d '\r'); \
        curl -o "/intel/$(basename ${i})" -L "${i}"; \
    done && \
    dpkg -i /intel/*.deb && \
    rm -rf /intel

# install plex
ARG VERSION
RUN debfile="/tmp/plex.deb" && wget2 -nc -O "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_amd64.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${VERSION}" > "${APP_DIR}/version" && \
    mkdir "${APP_DIR}/config" && ln -s "${CONFIG_DIR}" "${APP_DIR}/config/Plex Media Server"

COPY root/ /
