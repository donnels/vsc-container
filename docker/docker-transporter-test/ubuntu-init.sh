#!/bin/bash
set -e

echo "=== Ubuntu Squid Init ==="

# Process configuration template with environment variables
echo "Processing squid hybrid configuration template..."
envsubst '${DNS_SERVER}' < /etc/squid/squid.conf.template > /etc/squid/squid.conf

# Now call Ubuntu's original entrypoint with default args
echo "Calling Ubuntu's entrypoint..."
exec /usr/local/bin/entrypoint.sh -f /etc/squid/squid.conf -NYC
