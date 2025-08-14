# Test Ubuntu Default Entrypoint with Hybrid Config
FROM docker.io/ubuntu/squid:latest

# Install envsubst for template processing
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Copy our hybrid configuration template that combines Ubuntu defaults + forward proxy needs
COPY squid-ubuntu-hybrid.conf.template /etc/squid/squid.conf.template

# Create conf.d directory that Ubuntu expects
RUN mkdir -p /etc/squid/conf.d

# Create init script to process template before Ubuntu starts squid
COPY ubuntu-init.sh /usr/local/bin/ubuntu-init.sh
RUN chmod +x /usr/local/bin/ubuntu-init.sh

# Use our init script that processes template then calls Ubuntu's entrypoint
CMD ["/usr/local/bin/ubuntu-init.sh"]
