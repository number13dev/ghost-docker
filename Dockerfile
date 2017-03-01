FROM alpine

ADD config.js config.js
ADD copyAssets.sh copyAssets.sh
ADD delete_cache.sh delete_cache.sh
ADD install.sh install.sh
ADD nginx.conf nginx.conf
ADD update.sh update.sh
RUN chmod +x install.sh && chmod +x update.sh && chmod +x copyAssets.sh && chmod +x delete_cache.sh

RUN addgroup -S node && adduser -S -g node node
RUN adduser -D -u 1000 -g 'www' www

RUN apk update
RUN apk add openrc nodejs openssl nginx mysql-client

ADD start.sh start.sh
RUN chmod +x start.sh

RUN ./install.sh

EXPOSE 80 443

CMD ["./start.sh"]