FROM docker.io/ubuntu/squid:latest

# Install additional tools for debugging and template processing
RUN apt-get update && apt-get install -y \
    curl \
    dnsutils \
    net-tools \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Create proper directory structure
RUN mkdir -p /var/spool/squid /var/log/squid \
    && chown -R proxy:proxy /var/spool/squid /var/log/squid \
    && chmod 755 /var/spool/squid /var/log/squid

# Copy template and startup script
COPY squid6.conf.template /etc/squid/squid.conf.template
COPY squid-start.sh /usr/local/bin/squid-start.sh
RUN chmod +x /usr/local/bin/squid-start.sh

# Expose the proxy port
EXPOSE 3128

# CRITICAL: Override the Ubuntu image's entrypoint completely
ENTRYPOINT []
CMD ["/usr/local/bin/squid-start.sh"]
