FROM alpine:3.16.0

ENV TZ="Europe/Paris"
ENV PUID="99"
ENV PGID="100"
ENV SERVER_IP="192.168.1.43"
ENV SERVER_PORT="6667"
ENV SERVER_CHAN="#test"
ENV NICKNAME="II-Bot"

###############################################################################################################
##### Paquets nécessaires + TZ + création dossier workdir
###############################################################################################################
RUN echo "${TZ}" > /etc/timezone \
    && mkdir /app \
    && chmod -R 0777 /app \
    && apk add --update --no-cache --virtual .build_deps tar xz

###############################################################################################################
##### s6-overlaye
###############################################################################################################
ARG S6_OVERLAY_VERSION="3.1.0.1"
ARG S6_OVERLAY_ARCH="x86_64"

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

RUN rm -rf /tmp/*
RUN apk del .build_deps

###############################################################################################################
##### User alpine
###############################################################################################################
RUN adduser --disabled-password -h /app -u ${PUID} -G `getent group ${PGID} | cut -d: -f1` -s /bin/ash alpine
RUN passwd -d alpine
RUN echo 'alpine:123456' | chpasswd

###############################################################################################################
##### Installation de ii
###############################################################################################################
WORKDIR /app
RUN set -eux \  
    && wget https://dl.suckless.org/tools/ii-1.9.tar.gz && tar -xvf ii-1.9.tar.gz \
    && apk add --no-cache --virtual .build_deps build-base gcc \
    && cd ii-1.9/ && make clean install \
    && apk del .build_deps \
    && rm -R /app/ii-1.9/

###############################################################################################################
##### Copie des fichiers de rootfs/ vers / du container
###############################################################################################################
COPY rootfs /

VOLUME [ "/app" ]
ENTRYPOINT [ "/init" ]