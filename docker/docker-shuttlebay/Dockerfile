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

# Copy startup script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose HTTP and NOT HTTPS ports
EXPOSE 80

CMD ["/docker-entrypoint.sh"]
