FROM docker.io/codercom/code-server:latest

USER root

# Install additional packages for development
RUN apt-get update \
    && apt-get install -y \
        openssl \
        plantuml graphviz openjdk-17-jre-headless \
        curl wget git \
    && rm -rf /var/lib/apt/lists/*

# Copy extension installation script
COPY install_extensions.sh /usr/local/bin/install_extensions.sh
RUN chmod +x /usr/local/bin/install_extensions.sh

# Create necessary directories and set permissions
RUN mkdir -p /home/coder/.config/code-server /home/coder/.local/share/code-server /home/coder/code \
    && chown -R coder:coder /home/coder
# Use entrypoint script for code-server startup
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER coder

# Install VS Code extensions
RUN /usr/local/bin/install_extensions.sh

EXPOSE 8443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
