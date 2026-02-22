# nanowebserver

A dockerized web server with Nginx, PHP, Certbot, Tor and Supervisor.

## Usage

```bash
docker-compose up -d
```

## Website

The website is stored in the `www` directory, mounted as a volume at `/var/www` in the container.

## Configuration

Create a `.env` file in the root directory with the following variables:

- `DOMAIN`: The domain name of the website
- `CERTBOT_EMAIL`: The email address for Certbot
- `WEBSITE_PORT`: The port for the website (default: 80)
- `WEBSITE_SSL_PORT`: The port for the website SSL (default: 443)

## Additional Configuration

Create a directory `additional_config` in the root directory. The entire directory will be mounted as a volume at `/mnt/additional_config` in the container and `/mnt/additional_config/additional_config.sh` will be executed at startup.

## Logging

The logs are stored in the `log` directory, synchronized with the host system, mounted as a volume at `/var/log` in the container.

## Let's Encrypt

The Let's Encrypt certificates are stored in the `letsencrypt` directory, synchronized with the host system, mounted as a volume at `/etc/letsencrypt` in the container.

## Recipe: add Tor identity

Place your Tor identity files in the `additional_config/hidden_service` directory and create a `additional_config.sh` file with the following content:

```bash
mkdir -p /var/lib/tor/hidden_service
cp /mnt/additional_config/hidden_service/hs_ed25519_secret_key /var/lib/tor/hidden_service/
cp /mnt/additional_config/hidden_service/hs_ed25519_public_key /var/lib/tor/hidden_service/
cp /mnt/additional_config/hidden_service/hostname /var/lib/tor/hidden_service/
chmod 700 /var/lib/tor/hidden_service
chmod 600 /var/lib/tor/hidden_service/*
chown -R debian-tor:debian-tor /var/lib/tor/hidden_service
```
