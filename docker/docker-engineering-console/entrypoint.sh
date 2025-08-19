#!/bin/sh
exec /usr/bin/code-server /home/coder/code \
    --bind-addr 0.0.0.0:8443 \
    --auth password \
    --password ${PASSWORD} \
    --cert /etc/letsencrypt/live/${CERT_NAME}/fullchain.pem \
    --cert-key /etc/letsencrypt/live/${CERT_NAME}/privkey.pem \
    --welcome-text "${CODE_SERVER_AUTH_MESSAGE}"