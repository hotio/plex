FROM hotio/dotnetcore@sha256:ee29e0573ce844055e724eff308df38ed1e9a121255bb69d989fb2c3115f141c

ARG DEBIAN_FRONTEND="noninteractive"

ENV PLEX_CLAIM="" ADVERTISE_IP="" ALLOWED_NETWORKS="" PLEX_PASS="no"

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp
EXPOSE 3468/tcp

VOLUME ["/transcode"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        xmlstarlet uuid-runtime \
        python3-pkg-resources \
        python3-pip python3-setuptools build-essential python3-all-dev && \
    pip3 install --no-cache-dir --upgrade backoff~=1.9.0 certifi~=2019.9.11 chardet~=3.0.4 Click~=7.0 Flask~=1.1.1 idna~=2.8 itsdangerous~=1.1.0 Jinja2~=2.10 MarkupSafe~=1.1.1 oauthlib~=3.1.0 peewee~=2.10.2 psutil~=5.6.5 requests~=2.22.0 requests-oauthlib~=1.3.0 sqlitedict~=1.6.0 urllib3~=1.25.7 Werkzeug~=0.16.0 pyfiglet~=0.8.post1 && \
# clean up
    apt purge -y python3-pip python3-setuptools build-essential python3-all-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG PLEX_VERSION=1.18.9.2571-e106a8a91

# install app
RUN debfile="/tmp/plex.deb" && curl -fsSL -o "${debfile}" "https://downloads.plex.tv/plex-media-server-new/${PLEX_VERSION}/debian/plexmediaserver_${PLEX_VERSION}_armhf.deb" && dpkg -x "${debfile}" "${APP_DIR}" && rm "${debfile}" && echo "${PLEX_VERSION}" > "${APP_DIR}/version"

ARG PLEXAUTOSCAN_VERSION=4e31fb19d81ca9d7ff0fc2f362f9accfff979bc4

# install plexautoscan
RUN mkdir "${APP_DIR}/plexautoscan" && curl -fsSL "https://github.com/l3uddz/plex_autoscan/archive/${PLEXAUTOSCAN_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}/plexautoscan" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}/plexautoscan"

COPY root/ /
