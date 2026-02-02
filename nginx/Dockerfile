# ================================================================
# NGINX API GATEWAY - DOCKERFILE
# ================================================================

FROM nginx:1.25-alpine

# Install additional tools
RUN apk add --no-cache \
    curl \
    openssl \
    bash

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Default config (will be overridden by volume mount in development)
COPY nginx.dev.conf /etc/nginx/nginx.conf

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Create cache directories and runtime directory
RUN mkdir -p /var/cache/nginx/media \
    /var/cache/nginx/api \
    /var/www/certbot \
    /etc/nginx/ssl \
    /var/run/nginx

# Create self-signed SSL certificate for development
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/privkey.pem \
    -out /etc/nginx/ssl/fullchain.pem \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=LemonKorean/CN=localhost"

# Set permissions for UID 1000 (matching NAS mount ownership)
RUN chown -R 1000:1000 /var/cache/nginx /var/run/nginx \
    && chmod -R 755 /var/cache/nginx /var/run/nginx

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Expose ports
EXPOSE 80 443 3007

# Start nginx with custom entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
