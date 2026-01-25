#!/bin/bash

# ================================================================
# Let's Encrypt Setup Script (Production)
# ================================================================
# Sets up SSL certificates using Certbot and Let's Encrypt
# Requires: Domain name pointing to your server
# ================================================================

set -e

DOMAIN="${1:-example.com}"
EMAIL="${2:-admin@example.com}"
WEBROOT="/var/www/certbot"

echo "================================================================"
echo "Setting up Let's Encrypt SSL Certificate"
echo "================================================================"
echo "Domain: $DOMAIN"
echo "Email: $EMAIL"
echo ""

# Check if domain is provided
if [ "$DOMAIN" = "example.com" ]; then
    echo "⚠️  Error: Please provide a valid domain name"
    echo ""
    echo "Usage: $0 your-domain.com admin@your-domain.com"
    echo ""
    exit 1
fi

# Create webroot directory
echo "Creating webroot directory..."
mkdir -p "$WEBROOT"

# Install certbot if not installed
if ! command -v certbot &> /dev/null; then
    echo "Installing certbot..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update
        sudo apt-get install -y certbot
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y certbot
    else
        echo "⚠️  Please install certbot manually"
        exit 1
    fi
fi

# Obtain certificate
echo "Obtaining SSL certificate from Let's Encrypt..."
sudo certbot certonly \
    --webroot \
    --webroot-path="$WEBROOT" \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    --domain "$DOMAIN" \
    --domain "www.$DOMAIN"

# Create symlinks to nginx ssl directory
SSL_DIR="./ssl"
mkdir -p "$SSL_DIR"

echo "Creating symlinks..."
sudo ln -sf "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$SSL_DIR/fullchain.pem"
sudo ln -sf "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "$SSL_DIR/privkey.pem"

# Set up auto-renewal
echo "Setting up automatic renewal..."
(sudo crontab -l 2>/dev/null || true; echo "0 3 * * * certbot renew --quiet --post-hook 'docker restart nginx'") | sudo crontab -

echo ""
echo "✓ SSL certificate obtained successfully!"
echo ""
echo "Certificate: /etc/letsencrypt/live/$DOMAIN/fullchain.pem"
echo "Private Key: /etc/letsencrypt/live/$DOMAIN/privkey.pem"
echo ""
echo "Auto-renewal cron job added (runs daily at 3 AM)"
echo ""
echo "Next steps:"
echo "1. Update nginx.conf with your domain name"
echo "2. Restart nginx: docker-compose restart nginx"
echo ""
echo "================================================================"
