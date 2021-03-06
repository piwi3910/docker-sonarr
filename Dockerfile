FROM piwi3910/base:latest

LABEL maintainer="Pascal Watteel"


#
# Add sonarr init script.
#
COPY sonarr.sh /sonarr.sh

#
# Fix locales to handle UTF-8 characters.
#
ENV LANG C.UTF-8

#
# Specify versions of software to install.
#
ARG VERSION=DEFAULT

#
# Add (download) sonarr
#
ADD https://download.sonarr.tv/v3/main/${VERSION}/Sonarr.main.${VERSION}.linux.tar.gz /tmp/sonarr.tar.gz


#
# Install sonarr and requied dependencies
#
RUN adduser -u 666 -D -h /sonarr -s /bin/bash sonarr sonarr && \
    chmod 755 /sonarr.sh && \
    tar xzf /tmp/sonarr.tar.gz -C /tmp && \
    mv /tmp/Sonarr/* /sonarr/ && \
    apk update && \
	apk add --no-cache libmediainfo shadow && \
    apk add mono --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
	chown -R sonarr: sonarr && \
    rm -rf /tmp/Son* /tmp/son* && \
    mkdir -p /downloads && \
    mkdir -p /media && \
    chown -R sonarr:sonarr /media /downloads

#
# Fix mono bug not syncing ca certs into it's keystore
#
RUN cert-sync /etc/ssl/certs/ca-certificates.crt


#
# Define container settings.
#
VOLUME ["/datadir", "/downloads"]

EXPOSE 8989

#
# Start sonarr.
#

WORKDIR /sonarr

CMD ["/sonarr.sh"]
