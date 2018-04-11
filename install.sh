#!/bin/sh
echo "~~~~~~~~~~~~~~ running install ~~~~~~~~~~~~~~"

if [ -z "$ZIP_URL" ]; then
    echo "Downloading:"
    echo $ZIP_URL
else
    ZIP_URL=https://github.com/TryGhost/Ghost/releases/download/0.11.9/Ghost-0.11.9.zip
fi

wget ${ZIP_URL} -O ghost.zip
mkdir -p /var/www/ghost
chown -R www:www /var/lib/nginx
chown -R www:www /var/www
unzip -o ghost.zip -d /var/www/ghost

cd /var/www/ghost
pwd
npm install --production
cd /

echo "~~~~~~~~~~~~~~ ghost unzip done, install done ~~~~~~~~~~~~~~"