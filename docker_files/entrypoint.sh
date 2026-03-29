#!/bin/bash
set -e

# Create log directories
mkdir -p /var/log/exim4 /var/log/nginx /var/log/supervisor /run/php

# Remove default Nginx site
rm -f /etc/nginx/sites-enabled/default

# Set maximum upload size to 8 MB per file and 32 MB total
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 8M/' /etc/php/8.2/fpm/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/' /etc/php/8.2/fpm/php.ini

# Link config files
ln -sf /mnt/docker_files/supervisord.conf /etc/supervisor/conf.d/services.conf
ln -sf /mnt/docker_files/nginx.conf /etc/nginx/nginx.conf
ln -sf /mnt/docker_files/site.conf /etc/nginx/sites-enabled/site.conf

# Run additional config if provided
if [ -f /mnt/additional_config/configure.sh ]; then
    /mnt/additional_config/configure.sh
fi

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
