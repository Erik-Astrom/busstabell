# Statisk sida bakad in i en liten Caddy-image. Ingen byggkedja, ingen databas.
FROM caddy:2-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /srv/index.html
