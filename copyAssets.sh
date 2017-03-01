#!/bin/sh
rm -rf /var/www/ghost/content/static
mkdir -p /var/www/ghost/content/static
find /var/www/ghost/content/themes/ -name "assets" | xargs -i cp -R {} /var/www/ghost/content/static
