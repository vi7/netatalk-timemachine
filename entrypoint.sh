#!/bin/sh
#
# entrypoint.sh
#
# Startup script for Alpine Docker image with Time Machine service

set -e

# Netatalk start
echo "Starting Netatalk daemon..."
exec /usr/sbin/netatalk -d
