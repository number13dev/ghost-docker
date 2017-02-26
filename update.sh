#!/bin/sh
BKPDIR=/backup

echo "updating ghost blog"
mkdir -p ${BKPDIR}
echo "creating tar.gz"
tar -cpzf backup-ghost.tar.gz /var/www/ghost
echo "creating sql dump"
mysqldump -h $DB_HOST -p$DB_PW -u $DB_USR --all-databases > dump.sql

mv dump.sql ${BKPDIR}/dump.sql
mv backup-${ID}-ghost.tar.gz ${BKPDIR}/backup-ghost.tar.gz

echo "backup done"

wget https://ghost.org/zip/ghost-latest.zip -O ghost.zip

echo "deleting ghost core"
rm -rf /var/www/ghost/core
rm /var/www/ghost/*.js
rm /var/www/ghost/*.json

echo "stopping docker"
echo $(pwd)
cd /var/www/ghost

unzip -o ghost.zip -d /var/www/ghost
chown -R www:www /var/www

touch /var/www/ghost/.update

echo "done - please restart your docker container"