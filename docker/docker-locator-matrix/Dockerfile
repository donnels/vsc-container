FROM docker.io/coredns/coredns:latest

# Install envsubst for template processing
USER root
RUN apk add --no-cache gettext
USER coredns

# Copy template files
COPY Corefile /etc/coredns/Corefile
COPY hosts.template /etc/coredns/hosts.template
COPY coredns-init.sh /usr/local/bin/coredns-init.sh

USER root
RUN chmod +x /usr/local/bin/coredns-init.sh

# Use our init script that processes template then starts CoreDNS
ENTRYPOINT ["/usr/local/bin/coredns-init.sh"]
