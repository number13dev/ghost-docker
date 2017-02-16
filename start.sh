#!/bin/sh
echo "Hello from Ghost-Docker"

if [ $DB_USR = "root" ]; then
    exit 1
fi

echo "wait for database"
while !(mysqladmin -h $DB_HOST -u root -p$DB_ROOT_PW ping)
do
    echo "waiting 10seconds ..."
    sleep 10
done

echo "Setting up Database"
mysql -u root -p$DB_ROOT_PW -h $DB_HOST -se "DROP USER IF EXISTS '${DB_USR}'@'%';"
mysql -u root -p$DB_ROOT_PW -h $DB_HOST -se "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mysql -u root -p$DB_ROOT_PW -h $DB_HOST -se "CREATE USER IF NOT EXISTS '${DB_USR}'@'%' IDENTIFIED BY '${DB_PW}';"
mysql -u root -p$DB_ROOT_PW -h $DB_HOST -se "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USR}'@'%';"
mysql -u root -p$DB_ROOT_PW -h $DB_HOST -se "FLUSH PRIVILEGES;"


rm -rf /config_files_sub
mkdir /config_files_sub

cp config.js /config_files_sub/config.js
cp nginx.conf /config_files_sub/nginx.conf

sed -i "s#{{BLOG_DOMAIN}}#${BLOG_DOMAIN}#g" /config_files_sub/config.js

sed -i "s/{{MAIL_LOGIN}}/$MAIL_LOGIN/g" /config_files_sub/config.js
sed -i "s/{{MAIL_SERVER}}/$MAIL_SERVER/g" /config_files_sub/config.js
sed -i "s/{{MAIL_PASSWORD}}/$MAIL_PASSWORD/g" /config_files_sub/config.js


sed -i "s/{{DB_HOST}}/$DB_HOST/g" /config_files_sub/config.js
sed -i "s/{{DB_USR}}/$DB_USR/g" /config_files_sub/config.js
sed -i "s/{{DB_NAME}}/$DB_NAME/g" /config_files_sub/config.js
sed -i "s/{{DB_PW}}/$DB_PW/g" /config_files_sub/config.js

sed -i "s/{{MAINTENANCE}}/${MAINTENANCE:-false}/g" /config_files_sub/config.js

#nginx
sed -i "s/{{PORT}}/${PORT:-80}/g" /config_files_sub/nginx.conf
cp /config_files_sub/nginx.conf /etc/nginx/nginx.conf

echo "checking if content exists..."
if [ -d "/var/www/ghost/content/apps" ]; then
    echo "exists"
else
    unzip -o ghost.zip -d /var/www/ghost
fi

echo "copying config file..."
cp /config_files_sub/config.js /var/www/ghost/config.js

export DB_PW=foo
export DB_ROOT_PW=moo

cd /var/www/ghost
chown -R www:www /var/www/ghost
rc-service nginx start
npm start --production

/bin/sh
