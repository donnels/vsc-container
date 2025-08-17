# Multi-stage build to get CoreDNS binary and add template processing
FROM docker.io/coredns/coredns:latest AS coredns-binary

# Use Debian as base for shell and package management
FROM docker.io/debian:stable-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    gettext-base \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy CoreDNS binary from official image
COPY --from=coredns-binary /coredns /usr/local/bin/coredns

# Create coredns user
RUN groupadd -r coredns && \
    useradd -r -g coredns coredns

# Copy template files
COPY Corefile /etc/coredns/Corefile
COPY coredns-init.sh /usr/local/bin/coredns-init.sh

# Make script executable
RUN chmod +x /usr/local/bin/coredns-init.sh

# Switch to coredns user
USER coredns

# Use our init script that processes template then starts CoreDNS
ENTRYPOINT ["/usr/local/bin/coredns-init.sh"]
