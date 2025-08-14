#!/bin/sh
set -e

echo "=== CoreDNS Init ==="

# Process hosts template with environment variables
echo "Processing CoreDNS hosts template..."
sed -e "s/WARPBUBBLE_IP_LOCATOR_MATRIX_PLACEHOLDER/${WARPBUBBLE_IP_LOCATOR_MATRIX}/g" \
    -e "s/WARPBUBBLE_IP_TRANSPORTER_PLACEHOLDER/${WARPBUBBLE_IP_TRANSPORTER}/g" \
    -e "s/WARPBUBBLE_IP_ENGINEERING_CONSOLE_PLACEHOLDER/${WARPBUBBLE_IP_ENGINEERING_CONSOLE}/g" \
    -e "s/WARPBUBBLE_IP_DEFLECTOR_PLACEHOLDER/${WARPBUBBLE_IP_DEFLECTOR}/g" \
    -e "s/WARPBUBBLE_IP_SHUTTLEBAY_PLACEHOLDER/${WARPBUBBLE_IP_SHUTTLEBAY}/g" \
    -e "s/WARPBUBBLE_IP_CONSOLE_PLACEHOLDER/${WARPBUBBLE_IP_CONSOLE}/g" \
    -e "s/WARPBUBBLE_IP_TRANSPORTER_TEST_PLACEHOLDER/${WARPBUBBLE_IP_TRANSPORTER_TEST}/g" \
    -e "s/WARPBUBBLE_IP_OPTICAL_DATA_NETWORK_PLACEHOLDER/${WARPBUBBLE_IP_OPTICAL_DATA_NETWORK}/g" \
    /etc/coredns/hosts.template > /etc/coredns/hosts

echo "Generated hosts file:"
cat /etc/coredns/hosts

# Start CoreDNS with the provided arguments
echo "Starting CoreDNS..."
exec /coredns "$@"
