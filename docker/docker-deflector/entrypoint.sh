#!/bin/sh
set -e

# Check for required environment variable
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "CLOUDFLARE_API_TOKEN is not set!"
  exit 1
fi

cat <<EOF > /etc/letsencrypt/cloudflare.ini
dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN
EOF
chmod 600 /etc/letsencrypt/cloudflare.ini

# Function to generate certificate
generate_cert() {
  local domains="$1"
  local cert_name="$2"
  
  echo "Generating certificate for: $domains (name: $cert_name)"
  
  # Parse domains for certbot - build arguments properly
  DOMAINS_ARG=""
  IFS=','
  for domain in $domains; do
    # Trim whitespace and add -d flag
    domain=$(echo "$domain" | tr -d ' ')
    if [ -z "$DOMAINS_ARG" ]; then
      DOMAINS_ARG="-d $domain"
    else
      DOMAINS_ARG="$DOMAINS_ARG -d $domain"
    fi
  done
  unset IFS
  
  echo "Running: certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --cert-name $cert_name --non-interactive --agree-tos --email admin@$DOMAIN $DOMAINS_ARG"
  
  # Generate certificate with specific name
  /opt/certbot/bin/certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini \
    --dns-cloudflare-propagation-seconds 60 \
    --cert-name "$cert_name" \
    --non-interactive \
    --agree-tos \
    --email "admin@$DOMAIN" \
    $DOMAINS_ARG
}

# Generate web server certificate (for nginx HTTPS menu)
if [ "${GENERATE_WEB_CERT:-true}" = "true" ]; then
  if [ -n "$WEB_DOMAINS" ]; then
    generate_cert "$WEB_DOMAINS" "$WEB_CERT_NAME"
  else
    echo "WEB_DOMAINS not set, skipping web certificate"
  fi
fi

# Generate proxy certificate
if [ "${GENERATE_PROXY_CERT:-false}" = "true" ]; then
  if [ -n "$PROXY_DOMAINS" ]; then
    generate_cert "$PROXY_DOMAINS" "$PROXY_CERT_NAME"
  else
    echo "PROXY_DOMAINS not set, skipping proxy certificate"
  fi
fi

# Generate VS Code certificate
if [ "${GENERATE_VSCODE_CERT:-true}" = "true" ]; then
  if [ -n "$VSCODE_DOMAINS" ]; then
    generate_cert "$VSCODE_DOMAINS" "$VSCODE_CERT_NAME"
  else
    echo "VSCODE_DOMAINS not set, skipping VS Code certificate"
  fi
fi

echo "Certificate generation complete!"
echo "Available certificates:"
ls -la /etc/letsencrypt/live/

echo "Fixing certificate permissions for container access..."
# Make certificates readable by all users (needed for non-root containers)
find /etc/letsencrypt/live -name "*.pem" -exec chmod 644 {} \;
find /etc/letsencrypt/archive -name "*.pem" -exec chmod 644 {} \;

echo "Certificate permissions fixed!"
ls -la /etc/letsencrypt/live/*/
