#!/bin/sh
set -e

echo "=== Optical Data Network (MQTT) Startup ==="

# Process configuration template with environment variables
echo "Processing MQTT configuration template..."
envsubst < /mosquitto/config/mosquitto.conf.template > /mosquitto/config/mosquitto.conf

#echo "DEBUG: template" ; cat /mosquitto/config/mosquitto.conf.template
#echo "DEBUG: config" ; cat /mosquitto/config/mosquitto.conf

# Create default password file if it doesn't exist
if [ ! -f /mosquitto/config/passwd ]; then
    echo "Creating default MQTT user accounts..."
    touch /mosquitto/config/passwd
    chmod 600 /mosquitto/config/passwd
    # Add default users - these should be changed in production
    mosquitto_passwd -b /mosquitto/config/passwd system system_password
    mosquitto_passwd -b /mosquitto/config/passwd deflector deflector_cert_updates
    mosquitto_passwd -b /mosquitto/config/passwd engineering engineering_console
fi

# Create default ACL file if it doesn't exist
if [ ! -f /mosquitto/config/acl.conf ]; then
    echo "Creating default MQTT access control list..."
    cat > /mosquitto/config/acl.conf << EOF
# Default ACL for Optical Data Network
# System topics for certificates and core services
topic readwrite system/certificates/#
topic readwrite system/status/#
topic readwrite system/logs/#

# Service-specific topics
user deflector
topic readwrite certificates/#
topic read system/status/#

user engineering
topic readwrite engineering/#
topic read system/status/#
topic read certificates/status/#

user system
topic readwrite #
EOF
fi

# Ensure proper permissions
#ls -la /mosquitto/config /mosquitto/data /mosquitto/log
#chown -R mosquitto:mosquitto /mosquitto/config /mosquitto/data /mosquitto/log

echo "Starting MQTT broker on port 8883 (TLS)..."
exec "$@"
