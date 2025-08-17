FROM debian:stable-slim

LABEL maintainer="Warp Bubble Team"

# Install required tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        dnsutils \
        iproute2 \
        iputils-ping \
        net-tools \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy diagnostic script
COPY dns-diagnostic.sh /usr/local/bin/dns-diagnostic.sh
RUN chmod +x /usr/local/bin/dns-diagnostic.sh

# Set working directory
WORKDIR /diagnostics

# Set entrypoint to run the diagnostic script
CMD ["/usr/local/bin/dns-diagnostic.sh"]
