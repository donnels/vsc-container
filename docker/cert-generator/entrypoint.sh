#!/bin/sh
set -e

# Generate cloudflare.ini from environment variable
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "CLOUDFLARE_API_TOKEN is not set!"
  exit 1
fi

cat <<EOF > /etc/letsencrypt/cloudflare.ini
dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN
EOF
chmod 600 /etc/letsencrypt/cloudflare.ini

# Parse domains from env
DOMAINS_ARG=""
IFS=','
for domain in $DOMAINS; do
  DOMAINS_ARG="$DOMAINS_ARG -d $domain"
done

# Run certbot
exec certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini $DOMAINS_ARG
