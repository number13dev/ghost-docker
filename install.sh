#!/bin/sh
echo "~~~~~~~~~~~~~~ running install ~~~~~~~~~~~~~~"

wget https://github.com/TryGhost/Ghost/releases/download/0.11.9/Ghost-0.11.9.zip -O ghost.zip
mkdir -p /var/www/ghost
chown -R www-data:www-data /var/lib/nginx
chown -R www-data:www-data /var/www
unzip -o ghost.zip -d /var/www/ghost

cd /var/www/ghost
pwd
npm install --production
cd /

echo "~~~~~~~~~~~~~~ ghost unzip done, install done ~~~~~~~~~~~~~~"