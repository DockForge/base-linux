# syntax=docker/dockerfile:1

FROM alpine:3.19 as rootfs-layer

# environment
ENV ROOTFS=/root-out
ENV REL=v3.20
ARG TARGETPLATFORM=""
ARG ARCH=""

RUN echo "Building for platform: ${TARGETPLATFORM}"
RUN echo "Architecture set to: ${ARCH}"

RUN echo "RootFS set to: ${ROOTFS}"
RUN echo "Alpine release set to: ${REL}"
# RUN echo "Mirror set to: ${MIRROR}"

ENV MIRROR=http://dl-cdn.alpinelinux.org/alpine
ENV PACKAGES=alpine-baselayout,\
alpine-keys,\
apk-tools,\
busybox,\
libc-utils

# install packages
RUN apk add --no-cache bash xz

# build rootfs
RUN mkdir -p "$ROOTFS/etc/apk" && \
    { \
        echo "$MIRROR/$REL/main"; \
        echo "$MIRROR/$REL/community"; \
    } > "$ROOTFS/etc/apk/repositories" && \
    apk --root "$ROOTFS" --no-cache --keys-dir /etc/apk/keys add --arch $ARCH --initdb ${PACKAGES//,/ } && \
    sed -i -e 's/^root::/root:!:/' /root-out/etc/shadow

# set version for s6 overlay
ARG S6_OVERLAY_VERSION="v3.1.6.2"

# copy s6 overlay from assets directory
COPY src/assets/s6-overlay/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp/s6-overlay-noarch.tar.xz
COPY src/assets/s6-overlay/${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.xz /tmp/s6-overlay-${ARCH}.tar.xz
COPY src/assets/s6-overlay/${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp/s6-overlay-symlinks-noarch.tar.xz
COPY src/assets/s6-overlay/${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp/s6-overlay-symlinks-arch.tar.xz

# add s6 overlay
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-noarch.tar.xz
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-${ARCH}.tar.xz

# add s6 optional symlinks
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

# Runtime stage
FROM scratch
COPY --from=rootfs-layer /root-out/ /
ARG BUILD_DATE
ARG VERSION
ARG MODS_VERSION="v3"
ARG PKG_INST_VERSION="v1"
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Dublok"
LABEL org.opencontainers.image.source https://github.com/DockForge/base-linux

# copy mod scripts from assets directory
COPY src/assets/mod-scripts/docker-mods.${MODS_VERSION}.sh /docker-mods
COPY src/assets/mod-scripts/package-install.${PKG_INST_VERSION}.sh /etc/s6-overlay/s6-rc.d/init-mods-package-install/run

RUN \
printf "Version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version

# add local files
COPY src/root/ /

# Ensure correct permissions for all scripts in s6-overlay directory
RUN find /etc/s6-overlay/ -type f -exec chmod 744 {} \; && \
    chmod 744 /docker-mods

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" \
    S6_VERBOSITY=1 \
    S6_STAGE2_HOOK=/docker-mods \
    VIRTUAL_ENV=/dockforgeopy \
    PATH="/dockforgeopy/bin:$PATH"

RUN echo "**** install runtime packages ****" && \
    apk add --no-cache \
        alpine-release \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        findutils \
        jq \
        netcat-openbsd \
        procps-ng \
        shadow \
        tzdata && \
    echo "**** create abc user and make our folders ****" && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc && \
    mkdir -p \
        /app \
        /config \
        /defaults \
        /dockforgeopy && \
    echo "**** cleanup ****" && \
    rm -rf /tmp/*

ENTRYPOINT ["/init"]

