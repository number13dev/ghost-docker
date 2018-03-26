#!/bin/sh
echo "running install"
wget https://github.com/TryGhost/Ghost/releases/download/0.11.12/Ghost-0.11.12.zip -O ghost.zip
mkdir -p /var/www/ghost
chown -R www:www /var/lib/nginx
chown -R www:www /var/www
unzip -o ghost.zip -d /var/www/ghost

cd /var/www/ghost
pwd
npm install --production
cd /
