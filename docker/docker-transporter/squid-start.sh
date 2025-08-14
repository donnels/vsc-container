#!/bin/bash
set -e

echo "=== Squid 6 Forward Proxy Startup ==="

# Process configuration template with environment variables
echo "Processing squid configuration template..."
envsubst '${DNS_SERVER}' < /etc/squid/squid.conf.template > /etc/squid/squid.conf

# Ensure directories exist with proper permissions
mkdir -p /var/spool/squid /var/log/squid
chown -R proxy:proxy /var/spool/squid /var/log/squid

# Clear any existing Ubuntu config directory conflicts
rm -rf /etc/squid/conf.d/

# CRITICAL: Initialize cache directories ONCE and wait for completion
if [ ! -d "/var/spool/squid/00" ]; then
    echo "Initializing Squid cache directories..."
    squid -z -f /etc/squid/squid.conf
    echo "Cache initialization completed."
fi

# Ensure no stale PID files
rm -f /run/squid.pid

# Start Squid in foreground mode with proper signal handling
echo "Starting Squid 6 forward proxy on port 3128..."
exec squid -f /etc/squid/squid.conf -NYCd 1