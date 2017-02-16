FROM alpine

ADD config.js config.js
ADD start.sh start.sh
ADD default default

RUN addgroup -S node && adduser -S -g node node

ADD config.js config.js
ADD start.sh start.sh
ADD default default

RUN apk update
RUN apk add nodejs openssl nginx mysql-client

RUN wget https://ghost.org/zip/ghost-latest.zip -O ghost.zip
RUN mkdir -p /var/www/ghost
RUN unzip -o ghost.zip -d /var/www/ghost

RUN cd /var/www/ghost && npm install --production


RUN cp /default /etc/nginx/sites-available/default
RUN chmod +x start.sh

EXPOSE 80 443

CMD ["./start.sh"]