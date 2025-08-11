FROM docker.io/haproxy:alpine

# Install required tools
RUN apk add --no-cache openssl curl nginx

# Create directories
RUN mkdir -p /etc/haproxy/certs /var/www/html /etc/nginx

# Copy configuration files
COPY haproxy.cfg.template /etc/haproxy/haproxy.cfg.template
COPY nginx-temp.conf /etc/nginx/nginx.conf

# Copy LCARS static assets
COPY lcars/ /var/www/html/

# Create startup script for forward proxy
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'set -e' >> /docker-entrypoint.sh && \
    echo 'echo "=== HAProxy Forward Proxy Startup ==="' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Generate self-signed certificate for forward proxy' >> /docker-entrypoint.sh && \
    echo 'echo "Generating self-signed certificate for proxy..."' >> /docker-entrypoint.sh && \
    echo 'openssl req -x509 -newkey rsa:4096 \' >> /docker-entrypoint.sh && \
    echo '  -keyout /etc/haproxy/certs/proxy.key \' >> /docker-entrypoint.sh && \
    echo '  -out /etc/haproxy/certs/proxy.crt \' >> /docker-entrypoint.sh && \
    echo '  -days 365 -nodes \' >> /docker-entrypoint.sh && \
    echo '  -subj "/CN=forward-proxy.local/O=VSCode Container/OU=Development"' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Combine certificate and key for HAProxy' >> /docker-entrypoint.sh && \
    echo 'cat /etc/haproxy/certs/proxy.crt /etc/haproxy/certs/proxy.key > /etc/haproxy/certs/proxy.pem' >> /docker-entrypoint.sh && \
    echo 'chmod 600 /etc/haproxy/certs/proxy.pem' >> /docker-entrypoint.sh && \
    echo 'echo "Self-signed certificate generated and ready"' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Start nginx for LCARS interface in background (port 8081)' >> /docker-entrypoint.sh && \
    echo 'echo "Starting LCARS web interface on internal port 8081..."' >> /docker-entrypoint.sh && \
    echo 'nginx &' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Start HAProxy reverse proxy' >> /docker-entrypoint.sh && \
    echo 'echo "Starting HAProxy reverse proxy..."' >> /docker-entrypoint.sh && \
    echo 'echo "HTTPS access: https://localhost:8443"' >> /docker-entrypoint.sh && \
    echo 'echo "LCARS interface: http://localhost:8080"' >> /docker-entrypoint.sh && \
    echo 'exec haproxy -f /etc/haproxy/haproxy.cfg.template -db' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Expose forward proxy HTTPS and LCARS HTTP ports
EXPOSE 8443 8080

CMD ["/docker-entrypoint.sh"]
