#!/bin/sh
#
# entrypoint.sh
#
# Startup script for Alpine Docker image with Time Machine service

set -e

# TODO: implement dynamic user/group/volume addition

change_tm_pass() {
  # Change the default password of the Time Machine volume user configured at the image build time
  if [ "${TIMEMACHINE_PASSWORD}x" != "x" ]
  then
    echo $TIMEMACHINE_USER:$TIMEMACHINE_PASSWORD | chpasswd
  fi
}

__configure_media_vol() {

cat << EOF >> /etc/afp.conf

[$MEDIA_VOL_NAME]
path = $MEDIA_VOL_PATH
valid users = $MEDIA_USER
time machine = no
EOF


addgroup -g 1100 $MEDIA_USER
adduser -S -h $MEDIA_VOL_PATH -u 1100 -G $MEDIA_USER $MEDIA_USER
echo $MEDIA_USER:$MEDIA_PASSWORD | chpasswd

}

configure_media_vol()  {
  if [ "${MEDIA_USER}x" != "x" && \
      "${MEDIA_PASSWORD}x" != "x" && \
      "${MEDIA_VOL_PATH}x" != "x" && \
      "${MEDIA_VOL_NAME}x" != "x" && \
      grep -qw ${MEDIA_VOL_PATH} /etc/afp.conf ]
  then
    __configure_media_vol
  else
    echo "[ENTRYPOINT] [INFO] Media volume parameters hasn't been passed. Skipping its configuration"
  fi
}

run_netatalk() {
  # Cleaning staled lock file if container exited incorrectly
  rm -f /var/lock/netatalk

  # Netatalk start
  echo "[ENTRYPOINT] [INFO] Starting Netatalk daemon"
  exec /usr/sbin/netatalk -d
}

main() {
  configure_media_vol
  change_tm_pass
  run_netatalk
}

main $@
