# just another ghost docker container

**Don't run this in production! This container is in an early stage of development!**

This container is for use with [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)

Your config.js is overwritten everytime you start your container.

At the moment this container is a little big - needs tweaking. And it don't really
needs Nginx. But with it you could run this container in the wild.

```
docker run -t -i \
    -e BLOG_DOMAIN="https://www.example.com" \
    -e MAIL_SERVER="smtp.example.com" \
    -e MAIL_LOGIN="mymaillogin@example.com" \
    -e MAIL_PASSWORD="my-secret-mail-password" \
    -e DB_PW="my-ghost-db-password" \
    -e DB_HOST="my-database-url" \
    -e DB_USR="my-ghost-db-usr" \
    -e DB_NAME="my-ghost-db-name" \
    -e DB_ROOT_PW="my-secret-sql-root-pw" \
    -e PORT="80" \
    -e VIRTUAL_HOST="www.example.com,example.com" \
    -e VIRTUAL_NETWORK="nginx-proxy" \
    -e LETSENCRYPT_HOST="www.example.com,example.com" \
    -e LETSENCRYPT_EMAIL="mymail@example.com" \
    -v ~/ghostblogs/blog001:/var/www/ghost/content \
    number13/ghost-docker
```

Keep in mind that Ghost tries to connect on port 587 for the mail feature.

Docker compose example:
```
version: '2'
services:
  ghost:
    image: number13/ghost-docker
    restart: always
    networks:
      - proxy-tier
    environment:
        BLOG_DOMAIN: https://www.example.com
        MAIL: example@example.com
        DB_HOST: db
        DB_USR: ghost
        DB_NAME: ghost
        DB_PW: secret-pw
        DB_ROOT_PW: secret-root-pw
        PORT: 80
        VIRTUAL_HOST: example.com,example.com
        VIRTUAL_PORT: 80
        VIRTUAL_NETWORK: nginx-proxy
        LETSENCRYPT_HOST: example.com,www.example.com
        LETSENCRYPT_EMAIL: mail@example.com
        MAIL_SERVER: smtp.example.com
        MAIL_LOGIN: noreply@example.com
        MAIL_PASSWORD: secret-mail-pw
    volumes:
      - "~/blogs/ghostblog:/var/www/ghost/content"
networks:
  proxy-tier:
    external:
      name: nginx-proxy
```

#### BLOG_DOMAIN
Your Domain from your blog.

#### MAIL_SERVER
Your Mail Server where Ghost tries to connect to.

#### MAIL_LOGIN
Your Login to the Mail-Server

#### MAIL_PASSWORD
Your Password

#### DB_PW
Your Database Password

#### DB_USR
Your Database User

#### DB_NAME
Your Database Name for this Blog

#### DB_ROOT_PW
Your root password for your mysql

#### PORT
The Port where your ghost blog will be available. If you leave this out your Blog will be available at port 80.

#### VIRTUAL_HOST
Virtual Host for the nginx proxy. Your Domain where your Blog will be available

#### VIRTUAL_NETWORL
Your Virtual Network

#### LETSENCRYPT_HOST
Your Hostnames for Letsencrypt certificates

#### LETSENCRYPT_EMAIL
Your Letsencrypt email - for certifiate renewal reminder


##### Volumes
Just mount:
-v ~/ghostblogs/blog001:/var/www/ghost/content \
so you can backup your pictures etc.


