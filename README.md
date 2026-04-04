# nanowebserver

A minimal dockerized web server with Apache, PHP and Tor.

## Usage

1. Put your website files in `www`
2. Run  `docker compose up -d`

That's it: `www` is mounted to `/htdocs` inside the container and served by Apache.

## Customizing the application

Use `docker-compose.override.yml`. For example, if you want to rename the application and add an API key:

```yml
name: mycoolsite

services:
  web:
    environment:
      - API_KEY=abcd
```

## Traefik configuration

In your `docker-compose.override.yml`:

```yml
services:
  web:
    networks:
      - tor
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

## Tor

`hidden_service` contents are copied (**not** mounted) to `/var/lib/tor/hidden_service`. Place your Tor identity (`hostname` and keys) there.
