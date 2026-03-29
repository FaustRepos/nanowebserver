# nanowebserver

A minimal dockerized web server with Nginx, Certbot, PHP, Supervisord and Tor.

## Usage

Create an `.env` file in the root directory with the variable `DOMAIN=mywebsite.com` (see `.env.example`), then run:

```bash
docker-compose up -d
```

That's it. The website is served from the directory `www`, which is mounted in `/var/www` inside the container.

## Customization

Create a file `docker-compose.override.yml` to extend the stack and configuration. For example, if you want to use a Traefik proxy and add an API key:

```yml
services:
  website:
    container_name: my_cool_app
    networks:
      - traefik_traefik
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik_traefik"
      - "traefik.http.routers.my_cool_app.rule=HostRegexp(`^my_cool_app\\..+$`)"
      - "traefik.http.routers.my_cool_app.entrypoints=web"
      - "traefik.http.services.my_cool_app.loadbalancer.server.port=80"
    environment:
      - API_KEY=abcd

networks:
  traefik_traefik:
    external: true
```

## Additional Configuration

The directory `additional_config` is mounted in `/mnt/additional_config` inside the container, and `/mnt/additional_config/configure.sh` will be executed at startup.

## Logging

Logs are stored in the directory `log` mounted in `/var/log`.

## SSL

The directory `letsencrypt` is mounted in `/etc/letsencrypt`. If you enable SSL (see below), your will find your private key there: keep it safe!

## Open a shell to the container while it's running

```bash
docker exec -it nanowebserver /bin/bash
```

## Sample Recipe: add a Tor identity

Place your Tor identity files in `additional_config/hidden_service/` and create a file `configure.sh` with something like:

```bash
mkdir -p /var/lib/tor/hidden_service
cp /mnt/additional_config/torrc /etc/tor/torrc
cp /mnt/additional_config/hidden_service/hs_ed25519_secret_key /var/lib/tor/hidden_service/
cp /mnt/additional_config/hidden_service/hs_ed25519_public_key /var/lib/tor/hidden_service/
cp /mnt/additional_config/hidden_service/hostname /var/lib/tor/hidden_service/
chmod 700 /var/lib/tor/hidden_service
chmod 600 /var/lib/tor/hidden_service/*
chown -R debian-tor:debian-tor /var/lib/tor/hidden_service
```

## Sample Recipe: add SSL

Copy `docker_files/example.ssl.conf` to `additional_config/site.conf` and create a file `additional_config/configure.sh` with something like:

```bash
CERTBOT_EMAIL="webmaster@${DOMAIN}"

if [ ! -f /etc/letsencrypt/live/${DOMAIN}/fullchain.pem ]; then
    certbot certonly --standalone \
        -d "${DOMAIN}" \
        --non-interactive \
        --agree-tos \
        --email "${CERTBOT_EMAIL}" || true
fi
echo "0 3 * * * root certbot renew --quiet --deploy-hook 'nginx -s reload'" > /etc/cron.d/certbot-renew
chmod 0644 /etc/cron.d/certbot-renew

ln -sf /mnt/additional_config/site.conf /etc/nginx/sites-enabled/site.conf
```
