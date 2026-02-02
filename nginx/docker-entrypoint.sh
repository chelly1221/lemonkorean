#!/bin/sh
set -e

echo "[Nginx] Starting nginx as UID $(id -u)"

# Ensure cache directories have correct permissions
if [ -d /var/cache/nginx ]; then
    chown -R 1000:1000 /var/cache/nginx 2>/dev/null || true
fi

# Test configuration
nginx -t

# Start nginx
exec nginx -g "daemon off;"
