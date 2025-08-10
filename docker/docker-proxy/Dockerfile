FROM nginx:alpine

# Install envsubst (part of gettext package)
RUN apk add --no-cache gettext

# Copy nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Add LCARS static assets
COPY lcars/ /usr/share/nginx/html/lcars/

# Create directories for certificates
RUN mkdir -p /etc/nginx/certs

# Create startup script
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'envsubst "\$PROXY_CERT_NAME" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf' >> /docker-entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Expose HTTPS and LCARS UI ports
EXPOSE 443 8080

CMD ["/docker-entrypoint.sh"]
