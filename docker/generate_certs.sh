#!/bin/bash
set -e
CERT_DIR="/home/coder/.config/code-server/certs"
KEY_DIR="$CERT_DIR"
mkdir -p "$CERT_DIR"

# Generate trusted local cert with mkcert if available, else fallback to openssl
if command -v mkcert >/dev/null 2>&1; then
  if [ ! -f "$CERT_DIR/code-server.crt" ] || [ ! -f "$KEY_DIR/code-server.key" ]; then
    mkcert -cert-file "$CERT_DIR/code-server.crt" -key-file "$KEY_DIR/code-server.key" steamdeck.fritz.box localhost 127.0.0.1 ::1
    echo "mkcert certificate generated."
  else
    echo "Certificate already exists."
  fi
else
  if [ ! -f "$CERT_DIR/code-server.crt" ] || [ ! -f "$KEY_DIR/code-server.key" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout "$KEY_DIR/code-server.key" \
      -out "$CERT_DIR/code-server.crt" \
      -subj "/C=US/ST=State/L=City/O=Organization/OU=Org/CN=localhost"
    echo "Self-signed certificate generated."
  else
    echo "Certificate already exists."
  fi
fi

# Install recommended extensions if not already installed
EXT_LIST="jebbs.plantuml asciidoctor.asciidoctor-vscode"
for ext in $EXT_LIST; do
  if ! /usr/bin/code-server --list-extensions | grep -q "$ext"; then
    /usr/bin/code-server --install-extension "$ext"
  fi
done
