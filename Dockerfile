FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    nginx \
    php8.2-fpm \
    php8.2-gd \
    php8.2-mbstring \
    certbot \
    tor \
    supervisor \
    cron
RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -rf /var/lib/apt/lists/*

COPY docker_files/torrc /etc/tor/torrc
COPY docker_files/nginx.conf /etc/nginx/sites-available/nginx.conf
COPY docker_files/nginx.ssl.conf /etc/nginx/sites-available/nginx.ssl.conf
COPY docker_files/supervisord.conf /etc/supervisor/conf.d/services.conf
COPY docker_files/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
