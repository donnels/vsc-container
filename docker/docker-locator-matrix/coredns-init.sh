#!/bin/sh
set -e

echo "=== CoreDNS Init (Variable-Driven DNS) ==="

# Set default values if environment variables are not provided
WARP_DOMAIN="${WARP_DOMAIN:-warp.vsagcrd.org}"
BASE_DOMAIN="${BASE_DOMAIN:-vsagcrd.org}"

# Process Corefile template with environment variables
if [ -f "/etc/coredns/Corefile" ]; then
    echo "Processing Corefile template..."
    envsubst < /etc/coredns/Corefile > /etc/coredns/Corefile.processed
    mv /etc/coredns/Corefile.processed /etc/coredns/Corefile
fi

# Generate hosts file from environment variables
echo "Generating hosts file from WARPBUBBLE_SERVICES..."
echo "# Auto-generated hosts file from environment variables" > /etc/coredns/hosts
echo "# Generated at: $(date)" >> /etc/coredns/hosts
echo "# Domain: $WARP_DOMAIN" >> /etc/coredns/hosts
echo "" >> /etc/coredns/hosts

# Check if WARPBUBBLE_SERVICES is defined
if [ -z "$WARPBUBBLE_SERVICES" ]; then
    echo "Warning: WARPBUBBLE_SERVICES not defined, creating empty hosts file"
    touch /etc/coredns/hosts
else
    # Decode WARPBUBBLE_SERVICES compact format
    # Split on comma, handle service:alias format
    echo "$WARPBUBBLE_SERVICES" | tr ',' '\n' | while IFS= read -r service_def; do
        if [ -n "$service_def" ]; then
            # Parse service:alias format
            service_name=$(echo "$service_def" | cut -d':' -f1)
            alias_name=$(echo "$service_def" | cut -d':' -f2 -s)
            
            # Convert service name to uppercase with underscores for variable lookup
            ip_var="WARPBUBBLE_IP_$(echo "$service_name" | tr '[:lower:]-' '[:upper:]_')"
            ip_value=$(eval echo \$$ip_var)
            
            if [ -n "$ip_value" ]; then
                # Primary hostname
                echo "$ip_value $service_name.$WARP_DOMAIN" >> /etc/coredns/hosts
                echo "Added: $service_name.$WARP_DOMAIN -> $ip_value"
                
                # Add alias if specified and different from service name
                if [ -n "$alias_name" ] && [ "$alias_name" != "$service_name" ]; then
                    echo "$ip_value $alias_name.$WARP_DOMAIN" >> /etc/coredns/hosts
                    echo "Added: $alias_name.$WARP_DOMAIN -> $ip_value"
                fi
            else
                echo "Warning: No IP found for $service_name (variable: $ip_var)"
            fi
        fi
    done
fi

echo ""
echo "Generated hosts file:"
cat /etc/coredns/hosts

# Start CoreDNS with the provided arguments
echo "Starting CoreDNS for variable-driven DNS resolution..."
exec /usr/local/bin/coredns -conf /etc/coredns/Corefile "$@"
