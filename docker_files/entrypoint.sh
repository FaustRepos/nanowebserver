#!/bin/bash
set -e

mkdir -p /var/log/nginx /var/log/supervisor /run/php

if [ "${CERTBOT_ENABLED}" = "true" ]; then
    if [ ! -f /etc/letsencrypt/live/drfaust.ddns.net/fullchain.pem ]; then
        certbot certonly --standalone \
            -d ${DOMAIN} \
            --non-interactive \
            --agree-tos \
            --email ${CERTBOT_EMAIL} || true
    fi
    echo "0 3 * * * root certbot renew --quiet --deploy-hook 'nginx -s reload'" > /etc/cron.d/certbot-renew
    chmod 0644 /etc/cron.d/certbot-renew

    ln -s /etc/nginx/sites-available/nginx.ssl.conf /etc/nginx/sites-enabled/default
else
    ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/default
fi

if [ -f /mnt/additional_config/additional_config.sh ]; then
    /mnt/additional_config/additional_config.sh
fi

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
