FROM alpine

ADD config.js config.js
ADD nginx.conf nginx.conf

RUN addgroup -S node && adduser -S -g node node
RUN adduser -D -u 1000 -g 'www' www

RUN apk update
RUN apk add nodejs openssl nginx mysql-client

RUN wget https://ghost.org/zip/ghost-latest.zip -O ghost.zip
RUN mkdir -p /var/www/ghost
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /var/www
RUN unzip -o ghost.zip -d /var/www/ghost

RUN cd /var/www/ghost && npm install --production

ADD start.sh start.sh
RUN chmod +x start.sh

EXPOSE 80 443

CMD ["./start.sh"]