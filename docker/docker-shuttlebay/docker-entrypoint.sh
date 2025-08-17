#!/bin/sh
set -e

echo "=== Nginx Web Server Startup ==="

## Wait for Let's Encrypt certificates
#CERT_PATH="/etc/letsencrypt/live/${CERT_NAME}"
#echo "Waiting for Let's Encrypt certificates for $CERT_PATH..."
#while [ ! -f "$CERT_PATH/fullchain.pem" ]; do
#  echo "Waiting for certificates to be generated..."
#  sleep 5
#done
#echo "Certificates found, starting nginx..."

# Start nginx
exec nginx -g "daemon off;"
