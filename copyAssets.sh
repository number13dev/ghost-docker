#!/bin/sh
find /var/www/ghost/content/themes/ -name "assets" | xargs -i cp -R {} /var/www/ghost/content/static
