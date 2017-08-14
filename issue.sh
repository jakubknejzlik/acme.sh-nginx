#!/bin/sh

DOMAIN=$1

if [$DOMAIN = ""]; then
  echo "first argument (domain name) must be specified"
  exit 1
fi


echo "registering account"
THUMBPRINT=`acme.sh --register-account | grep "'.*'" | sed -n " s,[^']*'\([^']*\).*,\1,p "`
echo "registered; received thumbpring: $THUMBPRINT"

echo "updating nginx config"
echo "server {
  location ~ \"^/([-_a-zA-Z0-9]+)$\" {
    default_type text/plain;
    return 200 "\$1.$THUMBPRINT";
  }
}" > /etc/nginx/conf.d/default.conf

echo "reloading nginx"
nginx -s reload

echo "issuing certificate for $DOMAIN"
acme.sh --issue -d $DOMAIN --stateless
