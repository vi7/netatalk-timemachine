#!/usr/bin/env sh
#
# entrypoint.sh
#
# Startup script for Alpine Docker image with Time Machine service

set -e

# Cleaning staled lock file if container exited incorrectly
rm -f /var/lock/netatalk

# Netatalk start
echo "Starting Netatalk daemon"
exec /sbin/tini -- /usr/sbin/netatalk -d
