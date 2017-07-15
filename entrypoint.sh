#!/bin/sh
#
# entrypoint.sh
#
# Startup script for Alpine Docker image with Time Machine service

set -e

########
# VARS #
########
: ${AFP_LOG_FIFO:="/var/log/afpd_log"}

# Netatalk start
echo "Starting Netatalk daemon..."
exec /usr/sbin/netatalk -d
