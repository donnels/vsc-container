# Dockerfile for Cert Generator
FROM debian:stable-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    certbot \
    python3-pip \
    python3-venv \
    python3-setuptools \
    && python3 -m venv /opt/certbot \
    && /opt/certbot/bin/pip install --upgrade pip \
    && /opt/certbot/bin/pip install cloudflare==2.19.4 \
    && /opt/certbot/bin/pip install certbot-dns-cloudflare \
    && rm -rf /var/lib/apt/lists/*

# Set environment to use virtual environment
ENV PATH="/opt/certbot/bin:$PATH"
ENV VIRTUAL_ENV="/opt/certbot"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
