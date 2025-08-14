FROM docker.io/nginx:latest

# Install required tools for SSL and utilities
RUN apt-get update && apt-get install -y \
    openssl \
    curl \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /var/www/html /etc/nginx/conf.d

# Copy nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Copy LCARS static assets
COPY lcars/ /var/www/html/

# Create startup script for LCARS console
RUN echo '#!/bin/bash' > /docker-entrypoint.sh && \
    echo 'set -e' >> /docker-entrypoint.sh && \
    echo 'echo "=== LCARS Console Web Server Startup ==="' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Process nginx configuration template' >> /docker-entrypoint.sh && \
    echo 'echo "Processing nginx configuration..."' >> /docker-entrypoint.sh && \
    echo 'envsubst '\''${WARP_DOMAIN}'\'' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Start nginx' >> /docker-entrypoint.sh && \
    echo 'echo "Starting LCARS Console web server..."' >> /docker-entrypoint.sh && \
    echo 'echo "LCARS Console: http://console.${WARP_DOMAIN:-warp.vsagcrd.org}"' >> /docker-entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Expose HTTP and HTTPS ports
EXPOSE 80 443

CMD ["/docker-entrypoint.sh"]
