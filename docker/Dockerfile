FROM docker.io/codercom/code-server:latest

USER root

# Install additional packages and mkcert
RUN apt-get update && \
    apt-get install -y openssl graphviz openjdk-17-jre-headless libnss3-tools wget && \
    wget -O /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 && \
    chmod +x /usr/local/bin/mkcert && \
    rm -rf /var/lib/apt/lists/*

# Copy cert generation script
COPY generate_certs.sh /usr/local/bin/generate_certs.sh
RUN chmod +x /usr/local/bin/generate_certs.sh

# Ensure certs directory exists and is owned by coder
RUN mkdir -p /home/coder/.config/code-server/certs && chown -R coder:coder /home/coder/.config/code-server

USER coder

ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/generate_certs.sh; exec /usr/bin/code-server /data --bind-addr 0.0.0.0:8443 --auth password --cert /home/coder/.config/code-server/certs/code-server.crt --cert-key /home/coder/.config/code-server/certs/code-server.key"]

EXPOSE 8443
