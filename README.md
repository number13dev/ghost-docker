# ghost-docker
> just another ghost docker container

[![Docker Automated buil](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg?style=plastic)](https://hub.docker.com/r/number13/ghost-docker)

~~**Don't run this in production! This container is in an early stage of development!**~~

This container can be used with [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)

Your config.js is overwritten **everytime** you start your container.

It works well with [Alpine Linux](https://hub.docker.com/_/alpine/) and
has an integrated NGINX which acts as a Proxy.

The NGINX does some Caching. But `proxy_cache_valid` ist set to 1 minute.
This minute is sufficient enough to reduce load to the Ghost-Server.
You could choose a higher time, but if you publish your articles, it will take longer
until they're online.

The Ghost Admin Panel and the Preview-Function are not being cached.

The NGINX is configured in a way, that it propably needs another Proxy in front of it. For SSL etc.
I use the [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and so far, I had no problems with it.

### Testing on your local machine:

```
docker run -t -i \
    -e MAIL_SERVER="smtp.example.com" \
    -e MAIL_LOGIN="mymaillogin@example.com" \
    -e MAIL_PASSWORD="my-secret-mail-password" \
    -e PORT="80" \
    -p 80:80
    -v "~/ghost-testing/blogcontent:/var/www/ghost/content" \
    number13/ghost-docker
```

### Starting with [Docker Letsencrypt Companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion):

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
    -v "~/ghostblogs/blog001:/var/www/ghost/content" \
    number13/ghost-docker
```

Keep in mind that Ghost uses port 587 for the remote mail server.

Docker compose example:
```yaml
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

### Stand-Alone Compose:

[Stand Alone docker-compose](stand-alone.yml)

Rename it to `docker-compose.yml`, and edit your ENV variables to your needs.


## Persisting your Application
If you want to backup your Ghost-Data just mount:
`"~/myblogs/myghostcontent:/var/www/ghost/content"`

Then backup `~/myblogs/myghostcontent`.

You could backup your SQL with `mysqldump` which I prefer.
If you don't have `mysqldump` installed on your Host, consider: [Backup and restore a mysql database from a running Docker mysql container](https://gist.github.com/spalladino/6d981f7b33f6e0afe6bb)


## Environment variables
- `BLOG_DOMAIN`: Your Domain from your blog.
- `MAIL_SERVER`: Your Mail Server where Ghost tries to connect to.
- `MAIL_LOGIN`: Your Login to the Mail-Server
- `MAIL_PASSWORD`: Your Password
- `DB_PW`: Your Database Password
- `DB_USR`: Your Database User
- `DB_NAME`: Your Database Name for this Blog
- `DB_ROOT_PW`: Your root password for your mysql
- `PORT`: The Port where your ghost blog will be available. Default: **80**

Below: Parameters if you use [Docker Letsencrypt Companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
- `VIRTUAL_HOST`: Virtual Host for the nginx proxy. Your Domain where your Blog will be available
- `VIRTUAL_NETWORK`: Your Virtual Network
- `LETSENCRYPT_HOST`: Your Hostnames for Letsencrypt certificates
- `LETSENCRYPT_EMAIL`: Your Letsencrypt email - for certifiate renewal reminder

### Volumes
Just mount:
`-v ~/myblogs/blog:/var/www/ghost/content`
so you can backup your pictures etc.


## Update GHOST
You could of course just delete your old Container. Pull a new Image if there is one available.
And then restart your container.
Be sure you have backed up all your data. This works because there is no persitent data saved inside your container
**IF** you've mounted `/var/www/ghost/content` externally.

If there is no new Image available try this:
`docker exec -i -t YOUR_CONTAINER /update.sh`

This Script does a one-time-backup which gets overwritten every time you start this script.
So please backup your data in another way. If something went wrong during the script execution, you
can open a shell in your container like this:
`docker exec -i -t YOUR_CONTAINER /bin/sh`
In `/backup` should be an backup of your `/var/www/ghost`-Folder before the update.

###Security

If you don't want to give the container your ROOT-SQL Password. You can of course just add the
ghost-docker database user yourself.

```sql
"CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
"CREATE USER IF NOT EXISTS '${DB_USR}'@'%' IDENTIFIED BY '${DB_PW}';"
"GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USR}'@'%';"
"FLUSH PRIVILEGES;"
```

The variables `${DB_NAME}`, `${DB_USR}`, `${DB_PW}` needs to be set to the corresponding Environment Variables.
Be sure to set some fake password to your `DB_ROOT_PW`-Env variable otherwise the container won't start automatically.

