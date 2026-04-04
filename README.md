# nanowebserver

A minimal dockerized web server with Nginx, PHP and Tor.

## Usage

1. Make sure the directory `log` is writable
2. Create an `.env` with the variable `DOMAIN=mywebsite.com` (see `.env.example`)
3. Create a `site.conf` in `nginx/sites-enabled/` (copying `site.conf.example` is enough for a basic setup)
4. Run  `docker compose up`

That's it. The website is served from the directory `www`, which is mounted in `/var/www` inside the container.

## Customizing the application

Use `docker-compose.override.yml`. For example, if you want to rename the application and add an API key:

```yml
name: mycoolsite

services:
  web:
    environment:
      - API_KEY=abcd

networks:
  traefik_traefik:
    external: true
```

## Traefik basic configuration

In your `docker-compose.override.yml`:

```yml
services:
  web:
    networks:
      - default
      - traefik_traefik
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik_traefik"
      - "traefik.http.routers.mycoolsite.rule=Host(`mycoolsite.com`)"
      - "traefik.http.routers.mycoolsite.entrypoints=web"
      - "traefik.http.services.mycoolsite.loadbalancer.server.port=80"

networks:
  traefik_traefik:
    external: true
```

## Open a shell to a container while it's running

```bash
docker exec -it mycoolsite-web-1 /bin/bash
```

## Logging

Logs are stored in the directory `log` mounted in `/var/log` (make sure it's writable).

## Nginx

`nginx/nginx.conf` is mounted to `/etc/nginx/nginx.conf`.

`nginx/sites-enabled/` is mounted to `/etc/nginx/sites-enabled/`.

## PHP

`php/php.ini` is mounted to `/usr/local/etc/php/conf.d/php.ini` and parsed after the base configuration.

`php-fpm/www.conf` is mounted to `/usr/local/etc/php-fpm.d/www.conf`.

## Tor

`tor/hidden_service` is copied (**not** mounted) to `/var/lib/tor/hidden_service`. Place your Tor identity (`hostname` and keys) there.

You can disable Tor in your `docker-compose.override.yml`:

```yml
services:
  tor:
    profiles:
      - donotstart
```
