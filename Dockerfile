ARG ALPINE_VERSION=edge

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="Vitaliy D. <vi7alya@gmail.com>"
LABEL description="Netatalk AFP fileserver for the Apple TimeMachine backups"

# Build args
ARG AFP_VOL_PATH=/timemachine

# Env vars
ENV NETATALK_VERSION=3.1.11-r0 \
    AFP_VOL_PATH=${AFP_VOL_PATH}

WORKDIR /

ADD ["provision.sh", "entrypoint.sh", "/"]
RUN chmod u+x /provision.sh && \
    chmod u+x /entrypoint.sh && \
    ./provision.sh && \
    rm -f /provision.sh

VOLUME ${AFP_VOL_PATH}
# Preserve manual changes in /etc/afp.conf
VOLUME /etc
# Preserve Netatalk CNID DB data
# Check http://netatalk.sourceforge.net/2.0/htmldocs/configuration.html#CNID-backends for the details
VOLUME /var/netatalk

EXPOSE 548

CMD ["/entrypoint.sh"]