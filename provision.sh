#!/bin/sh
#
# provision.sh
#
# Provision Alpine Docker image with Time Machine service
# based on Netatalk
#
# Additional information:
# http://netatalk.sourceforge.net
# https://wiki.alpinelinux.org/wiki

set -e

########
# VARS #
########

: ${TIMEMACHINE_USER:="tmbackup"}
: ${TIMEMACHINE_PASSWORD:="$TIMEMACHINE_USER"}
: ${TIMEMACHINE_VOL_PATH:="/timemachine"}
# AFP vol size for the Time Machine backups. Default: 250GB
: ${TIMEMACHINE_VOL_SIZE_LIMIT:=262144000}

########
# MAIN #
########

# Install Netatalk and cleanup apk cache
apk update
apk add netatalk=$NETATALK_VERSION
rm -f /var/cache/apk/APKINDEX.*

# Netatalk configuration
cat << EOF > /etc/afp.conf
[Global]
mimic model = AirPort
# AFPD logs published to stdout in order to be managed correctly by Docker
log file = /dev/stdout
log level = default:info
zeroconf = no
# TODO: monitor transfer speed changes
dsireadbuf = 24

[Time Machine]
path = $TIMEMACHINE_VOL_PATH
valid users = $TIMEMACHINE_USER
time machine = yes
# the max size of the data folder (in Kb)
vol size limit = $TIMEMACHINE_VOL_SIZE_LIMIT
EOF

# Add user
addgroup -g 1102 $TIMEMACHINE_USER
adduser -S -h $TIMEMACHINE_VOL_PATH -u 1102 -G $TIMEMACHINE_USER $TIMEMACHINE_USER
echo $TIMEMACHINE_USER:$TIMEMACHINE_PASSWORD | chpasswd

# Create mountpoint
mkdir -p $TIMEMACHINE_VOL_PATH
chown -R $TIMEMACHINE_USER:$TIMEMACHINE_USER $TIMEMACHINE_VOL_PATH

