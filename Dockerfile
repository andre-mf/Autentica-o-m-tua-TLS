FROM nginx:stable-alpine

WORKDIR /certs
COPY server.crt server.key ca.crt client.p12 /certs/
COPY default.conf /etc/nginx/conf.d/

EXPOSE 443