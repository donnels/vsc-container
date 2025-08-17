FROM docker.io/eclipse-mosquitto:latest

# Install additional tools for debugging and certificate management
USER root
RUN apk add --no-cache \
    openssl \
    curl \
    gettext

# Create proper directory structure with correct permissions
RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log \
    && chown -R mosquitto:mosquitto /mosquitto

# Copy configuration files
COPY mosquitto.conf.template /mosquitto/config/mosquitto.conf.template
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch back to mosquitto user
USER mosquitto

# Expose MQTT over TLS port
EXPOSE 8883

# Use our custom entrypoint that processes templates
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
