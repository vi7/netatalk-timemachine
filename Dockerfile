ARG ALPINE_VERSION=edge

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="Vitaliy D. <vi7alya@gmail.com>"
LABEL description="Netatalk AFP fileserver for the Apple TimeMachine backups"

# Build args
ARG AFP_VOL_PATH=/timemachine

# Env vars
ENV NETATALK_VERSION=3.1.10-r1 \
    AFP_VOL_PATH=${AFP_VOL_PATH} \
    AFP_LOG_FIFO=/var/log/afpd_log

WORKDIR /

ADD ["provision.sh", "entrypoint.sh", "/"]
RUN chmod u+x /provision.sh && \
    chmod u+x /entrypoint.sh && \
    ./provision.sh && \
    rm -f /provision.sh

VOLUME ${AFP_VOL_PATH}
VOLUME /etc

EXPOSE 548

CMD ["/entrypoint.sh"]