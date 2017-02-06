#!/bin/sh

/usr/local/bin/dockerize -template /etc/nginx/service.tmpl:/etc/nginx/service.conf

/usr/local/openresty/nginx/sbin/nginx