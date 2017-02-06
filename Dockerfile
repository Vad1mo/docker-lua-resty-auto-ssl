FROM openresty/openresty:alpine-fat

ENV VERSION v0.3.0
ENV DOWNLOAD_URL http://github.com/jwilder/dockerize/releases/download/$VERSION/dockerize-alpine-linux-amd64-$VERSION.tar.gz

RUN apk add --no-cache bash openssl ca-certificates && \
    /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl && \
    openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -subj '/CN=sni-support-required-for-valid-ssl' -keyout /etc/ssl/resty-auto-ssl-fallback.key -out /etc/ssl/resty-auto-ssl-fallback.crt && \
    wget -qO- $DOWNLOAD_URL | tar xvz -C /usr/local/bin &&\
    mkdir -p /var/lib/certs && chown nobody:nobody /var/lib/certs

ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD service.tmpl /etc/nginx/service.tmpl
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/sh","-c","/entrypoint.sh"]
