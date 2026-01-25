#!/bin/bash

# ================================================================
# SSL Certificate Generation Script
# ================================================================
# Generates self-signed SSL certificates for development
# For production, use Let's Encrypt (certbot)
# ================================================================

set -e

SSL_DIR="./ssl"
DAYS=365
COUNTRY="KR"
STATE="Seoul"
CITY="Seoul"
ORG="LemonKorean"
CN="localhost"

echo "================================================================"
echo "Generating Self-Signed SSL Certificate"
echo "================================================================"

# Create SSL directory if it doesn't exist
mkdir -p "$SSL_DIR"

# Generate private key
echo "Generating private key..."
openssl genrsa -out "$SSL_DIR/privkey.pem" 2048

# Generate certificate signing request
echo "Generating certificate signing request..."
openssl req -new \
    -key "$SSL_DIR/privkey.pem" \
    -out "$SSL_DIR/cert.csr" \
    -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/CN=$CN"

# Generate self-signed certificate
echo "Generating self-signed certificate..."
openssl x509 -req \
    -days $DAYS \
    -in "$SSL_DIR/cert.csr" \
    -signkey "$SSL_DIR/privkey.pem" \
    -out "$SSL_DIR/fullchain.pem"

# Clean up CSR
rm "$SSL_DIR/cert.csr"

# Set permissions
chmod 600 "$SSL_DIR/privkey.pem"
chmod 644 "$SSL_DIR/fullchain.pem"

echo ""
echo "✓ SSL certificate generated successfully!"
echo ""
echo "Certificate: $SSL_DIR/fullchain.pem"
echo "Private Key: $SSL_DIR/privkey.pem"
echo "Valid for: $DAYS days"
echo ""
echo "⚠️  This is a self-signed certificate for DEVELOPMENT only!"
echo "⚠️  For production, use Let's Encrypt: certbot certonly --webroot"
echo ""
echo "================================================================"
