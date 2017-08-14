FROM neilpang/acme.sh

RUN apk update && apk add nginx && mkdir /run/nginx
