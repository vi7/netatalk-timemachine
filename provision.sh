#!/usr/bin/env sh
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

AFP_VOL_USERNAME="tmbackup"
AFP_VOL_PASSWORD="tmbackup"
: "${AFP_VOL_PATH:="/timemachine"}"
# AFP vol size for the Time Machine backups. Default: 250GB
: "${AFP_VOL_SIZE_LIMIT:=262144000}"

########
# MAIN #
########

echo "Installing packages"
apk add --no-cache tini netatalk="$NETATALK_VERSION"

echo "Configuring netatalk"
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
path = $AFP_VOL_PATH
valid users = $AFP_VOL_USERNAME
time machine = yes
# the max size of the data folder (in Kb)
vol size limit = $AFP_VOL_SIZE_LIMIT
EOF

echo "Adding users"
addgroup -g 1102 $AFP_VOL_USERNAME
adduser -S -h $AFP_VOL_PATH -u 1102 -G $AFP_VOL_USERNAME $AFP_VOL_USERNAME
echo $AFP_VOL_USERNAME:$AFP_VOL_PASSWORD | chpasswd

echo "Creating mount points"
mkdir -p $AFP_VOL_PATH
chown -R $AFP_VOL_USERNAME:$AFP_VOL_USERNAME $AFP_VOL_PATH
