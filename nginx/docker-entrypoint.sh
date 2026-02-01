#!/bin/sh
set -e

echo "[Nginx] Starting nginx"

# Test configuration
nginx -t

# Start nginx
exec nginx -g "daemon off;"
