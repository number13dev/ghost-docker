FROM ubuntu

ADD config.js config.js
ADD copyAssets.sh copyAssets.sh
ADD delete_cache.sh delete_cache.sh
ADD install.sh install.sh
ADD nginx.conf nginx.conf
ADD update.sh update.sh

RUN apt-get update
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y openssl
RUN apt-get install -y nginx
RUN apt-get install -y mysql-client
RUN apt-get install -y unzip
RUN apt-get install -y wget


RUN chmod +x install.sh && chmod +x update.sh && chmod +x copyAssets.sh && chmod +x delete_cache.sh

RUN addgroup node
RUN addgroup www
RUN adduser --system node
RUN adduser node node
RUN adduser www
RUN adduser www www

ADD start.sh start.sh
RUN chmod +x start.sh

RUN ./install.sh

EXPOSE 80 443

CMD ["./start.sh"]