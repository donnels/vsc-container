#!/bin/sh
set -e

echo "=== CoreDNS Init ==="

# Process hosts template with environment variables
echo "Processing CoreDNS hosts template..."
sed -e "s/WARPBUBBLE_IP_COREDNS_PLACEHOLDER/${WARPBUBBLE_IP_COREDNS}/g" \
    -e "s/WARPBUBBLE_IP_SQUID_PLACEHOLDER/${WARPBUBBLE_IP_SQUID}/g" \
    -e "s/WARPBUBBLE_IP_CODE_SERVER_PLACEHOLDER/${WARPBUBBLE_IP_CODE_SERVER}/g" \
    -e "s/WARPBUBBLE_IP_DEFLECTOR_PLACEHOLDER/${WARPBUBBLE_IP_DEFLECTOR}/g" \
    -e "s/WARPBUBBLE_IP_NGINX_WEB_PLACEHOLDER/${WARPBUBBLE_IP_NGINX_WEB}/g" \
    -e "s/WARPBUBBLE_IP_CONSOLE_PLACEHOLDER/${WARPBUBBLE_IP_CONSOLE}/g" \
    -e "s/WARPBUBBLE_IP_SQUID_UBUNTU_TEST_PLACEHOLDER/${WARPBUBBLE_IP_SQUID_UBUNTU_TEST}/g" \
    -e "s/WARPBUBBLE_IP_MQTT_PLACEHOLDER/${WARPBUBBLE_IP_MQTT}/g" \
    /etc/coredns/hosts.template > /etc/coredns/hosts

echo "Generated hosts file:"
cat /etc/coredns/hosts

# Start CoreDNS with the provided arguments
echo "Starting CoreDNS..."
exec /coredns "$@"
