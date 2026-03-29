FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y \
    nginx \
    certbot \
    php8.2-fpm \
    php8.2-gd \
    php8.2-mbstring \
    supervisor \
    cron
RUN apt-get install -y tor
ENTRYPOINT ["/mnt/docker_files/entrypoint.sh"]
