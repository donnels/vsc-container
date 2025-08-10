# Dockerfile for Cert Generator
FROM debian:stable-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    certbot \
    python3-certbot-dns-cloudflare \
    && rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
