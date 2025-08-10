FROM nginx:alpine

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create directories for certificates
RUN mkdir -p /etc/nginx/certs

# Expose HTTPS port
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
