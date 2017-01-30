FROM ubuntu

ADD config.js config.js
ADD start.sh start.sh
ADD default default

RUN apt-get update

RUN apt-get install -y \
    mysql-client \
    curl unzip nginx

RUN curl -sL https://deb.nodesource.com/setup_6.x | /bin/bash -
RUN apt-get install -y nodejs

RUN npm -v

RUN curl -L https://ghost.org/zip/ghost-latest.zip -o ghost.zip
RUN mkdir -p /var/www/ghost
RUN unzip -uo ghost.zip -d /var/www/ghost


WORKDIR /var/www/ghost
RUN npm install --production
WORKDIR /

RUN cp /default /etc/nginx/sites-available/default

RUN chmod +x start.sh

EXPOSE 80 443

CMD ["./start.sh"]