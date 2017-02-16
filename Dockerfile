FROM alpine

ADD config.js config.js
ADD install.sh install.sh
ADD nginx.conf nginx.conf
RUN chmod +x install.sh

RUN addgroup -S node && adduser -S -g node node
RUN adduser -D -u 1000 -g 'www' www

RUN apk update
RUN apk add nodejs openssl nginx mysql-client openrc

ADD start.sh start.sh
RUN chmod +x start.sh

RUN ./install.sh

EXPOSE 80 443

CMD ["./start.sh"]