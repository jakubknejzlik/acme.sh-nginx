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

echo "issuing certificate"
acme.sh --issue -d www.knejzlik.cz  --stateless
