FROM docker.io/nginx:latest

# Install openssl for certificate generation
RUN apt-get update && apt-get install -y \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /etc/nginx/certs /var/www/html

# Copy static content
COPY html/ /var/www/html/
COPY nginx.conf /etc/nginx/nginx.conf

# Create startup script
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'set -e' >> /docker-entrypoint.sh && \
    echo 'echo "=== Nginx Web Server Startup ==="' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Wait for Let'\''s Encrypt certificates' >> /docker-entrypoint.sh && \
    echo 'echo "Waiting for Let'\''s Encrypt certificates..."' >> /docker-entrypoint.sh && \
    echo 'while [ ! -f /etc/letsencrypt/live/www/fullchain.pem ]; do' >> /docker-entrypoint.sh && \
    echo '  echo "Waiting for certificates to be generated..."' >> /docker-entrypoint.sh && \
    echo '  sleep 5' >> /docker-entrypoint.sh && \
    echo 'done' >> /docker-entrypoint.sh && \
    echo 'echo "Certificates found, starting nginx..."' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Start nginx' >> /docker-entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Expose HTTP and HTTPS ports
EXPOSE 80 443

CMD ["/docker-entrypoint.sh"]
