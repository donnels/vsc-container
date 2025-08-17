#!/bin/sh
set -e

# Check for required environment variable
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "CLOUDFLARE_API_TOKEN is not set!"
  exit 1
fi

if [ -z "$WARPBUBBLE_SERVICES" ]; then
  echo "WARPBUBBLE_SERVICES is not set!"
  exit 1
fi

cat <<EOF > /etc/letsencrypt/cloudflare.ini
dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN
EOF
chmod 600 /etc/letsencrypt/cloudflare.ini

# Function to generate certificate for a service and its aliases
generate_cert() {
  local cert_name="$1"
  shift
  local domains="-d $cert_name"
  for alias_fqdn in "$@"; do
    domains="$domains -d $alias_fqdn"
  done
  echo "Generating certificate for: $cert_name $* (name: $cert_name)"
  /opt/certbot/bin/certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini \
    --dns-cloudflare-propagation-seconds 60 \
    --cert-name "$cert_name" \
    --non-interactive \
    --agree-tos \
    --email "admin@$DOMAIN" \
    $domains
}

# Loop over WARPBUBBLE_SERVICES and generate certs
for entry in $(echo "$WARPBUBBLE_SERVICES" | tr ',' '\n'); do
  service=$(echo "$entry" | cut -d':' -f1)
  cert_name="$service.$CERT_DOMAIN"
  alias_fields=$(echo "$entry" | cut -d':' -f2-)
  alias_fqdns=""
  if [ -n "$alias_fields" ]; then
    # Split aliases by ':' and append to alias_fqdns string
    oldIFS="$IFS"
    IFS=':'
    for alias in $alias_fields; do
      if [ -n "$alias" ]; then
        alias_fqdns="$alias_fqdns $alias.$CERT_DOMAIN"
      fi
    done
    IFS="$oldIFS"
  fi
  # Call generate_cert with cert_name and all aliases as arguments
  generate_cert "$cert_name" $alias_fqdns
done

echo "Certificate generation complete!"
echo "Available certificates:"
ls -la /etc/letsencrypt/live/

# Make certificates readable by all users (needed for non-root containers)
find /etc/letsencrypt/live -name "*.pem" -exec chmod 644 {} \;
find /etc/letsencrypt/archive -name "*.pem" -exec chmod 644 {} \;

echo "Certificate permissions fixed!"
ls -la /etc/letsencrypt/live/*/
