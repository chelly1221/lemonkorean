#!/bin/sh
set -e

echo "[Nginx] Starting with mode: ${NGINX_MODE:-production}"

# Choose config based on environment
if [ "$NGINX_MODE" = "development" ]; then
    echo "[Nginx] Using DEVELOPMENT configuration (HTTP only)"
    if [ -f /nginx-configs/nginx.dev.conf ]; then
        cp /nginx-configs/nginx.dev.conf /etc/nginx/nginx.conf
    else
        echo "ERROR: nginx.dev.conf not found!"
        exit 1
    fi
else
    echo "[Nginx] Using PRODUCTION configuration (HTTPS)"
    if [ -f /nginx-configs/nginx.conf ]; then
        cp /nginx-configs/nginx.conf /etc/nginx/nginx.conf
    else
        echo "ERROR: nginx.conf not found!"
        exit 1
    fi
fi

# Test configuration
nginx -t

# Start nginx
exec nginx -g "daemon off;"
