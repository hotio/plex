FROM hotio/base@sha256:c6bf3ec95093f75a2ff3e6ddfb15f3151da3ef6822a3892db23fa147fec7bed5

ARG DEBIAN_FRONTEND="noninteractive"

ENV PLEX_CLAIM="" ADVERTISE_IP="" ALLOWED_NETWORKS="" PLEX_PASS="no"

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp
EXPOSE 3468/tcp

VOLUME ["/transcode"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        xmlstarlet \
        python3-pkg-resources \
        python3-pip python3-setuptools build-essential python3-all-dev && \
    pip3 install --no-cache-dir --upgrade backoff~=1.9.0 certifi~=2019.9.11 chardet~=3.0.4 Click~=7.0 Flask~=1.1.1 idna~=2.8 itsdangerous~=1.1.0 Jinja2~=2.10 MarkupSafe~=1.1.1 oauthlib~=3.1.0 peewee~=2.10.2 psutil~=5.6.5 requests~=2.22.0 requests-oauthlib~=1.3.0 sqlitedict~=1.6.0 urllib3~=1.25.7 Werkzeug~=0.16.0 pyfiglet~=0.8.post1 && \
# clean up
    apt purge -y python3-pip python3-setuptools build-essential python3-all-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install plexautoscan
ARG PLEXAUTOSCAN_VERSION
RUN mkdir "${APP_DIR}/plexautoscan" && curl -fsSL "https://github.com/l3uddz/plex_autoscan/archive/${PLEXAUTOSCAN_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}/plexautoscan" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}/plexautoscan"

# install rclone
ARG RCLONE_VERSION
RUN debfile="/tmp/rclone.deb" && curl -fsSL -o "${debfile}" "https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

# install plex
ARG PLEX_VERSION
RUN debfile="/tmp/plex.deb" && curl -fsSL -o "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${PLEX_VERSION}/debian/plexmediaserver_${PLEX_VERSION}_arm64.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${PLEX_VERSION}" > "${APP_DIR}/version"

COPY root/ /

ARG LABEL_CREATED
LABEL org.opencontainers.image.created=$LABEL_CREATED
ARG LABEL_TITLE
LABEL org.opencontainers.image.title=$LABEL_TITLE
ARG LABEL_REVISION
LABEL org.opencontainers.image.revision=$LABEL_REVISION
ARG LABEL_SOURCE
LABEL org.opencontainers.image.source=$LABEL_SOURCE
ARG LABEL_VENDOR
LABEL org.opencontainers.image.vendor=$LABEL_VENDOR
ARG LABEL_URL
LABEL org.opencontainers.image.url=$LABEL_URL
ARG LABEL_VERSION
LABEL org.opencontainers.image.version=$LABEL_VERSION
