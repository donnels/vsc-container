#!/bin/sh
set -e

echo "=== CoreDNS Init (External DNS Only) ==="

echo "CoreDNS configured for external DNS forwarding only."
echo "Internal .warp.vsagcrd.org domains handled by Docker Compose aliases."

# Start CoreDNS with the provided arguments
echo "Starting CoreDNS for external DNS resolution..."
exec /coredns "$@"
