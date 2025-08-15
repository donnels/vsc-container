FROM debian:stable-slim

# Install DNS utilities and networking tools
RUN apt-get update && apt-get install -y \
    dnsutils \
    iputils-ping \
    curl \
    netcat-traditional \
    host \
    dig \
    nslookup \
    traceroute \
    telnet \
    && rm -rf /var/lib/apt/lists/*

# Copy test script
COPY dns-diagnostic.sh /usr/local/bin/dns-diagnostic.sh
RUN chmod +x /usr/local/bin/dns-diagnostic.sh

# Set working directory
WORKDIR /diagnostics

# Default command runs the diagnostic script
CMD ["/usr/local/bin/dns-diagnostic.sh"]
