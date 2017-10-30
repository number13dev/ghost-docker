#!/bin/sh
echo "running install"
wget https://ghost.org/zip/ghost-latest.zip -O ghost.zip
mkdir -p /var/www/ghost
chown -R www:www /var/lib/nginx
chown -R www:www /var/www
unzip -o ghost.zip -d /var/www/ghost

cd /var/www/ghost
pwd
npm install --production
npm install -g knex-migrator
cd /
