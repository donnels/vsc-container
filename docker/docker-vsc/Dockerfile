FROM docker.io/codercom/code-server:latest

USER root

# Install additional packages and mkcert
RUN apt-get update \
    && apt-get install -y \
        openssl \
        plantuml graphviz openjdk-17-jre-headless \
        libnss3-tools \
        wget curl \
    && wget -O /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 \
    && chmod +x /usr/local/bin/mkcert \
    && rm -rf /var/lib/apt/lists/*

# Copy cert generation script
COPY generate_certs.sh /usr/local/bin/generate_certs.sh
RUN chmod +x /usr/local/bin/generate_certs.sh

# Ensure all parent directories exist and are owned by coder
RUN mkdir -p /home/coder/.config/code-server/certs /home/coder/.local/share/mkcert \
    && chown -R coder:coder /home/coder/.config/code-server /home/coder/.local/share

USER coder

ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/generate_certs.sh; exec /usr/bin/code-server /data --bind-addr 0.0.0.0:8443 --auth password --cert /home/coder/.config/code-server/certs/code-server.crt --cert-key /home/coder/.config/code-server/certs/code-server.key"]

EXPOSE 8443
