FROM --platform=linux/amd64 php:8.0-fpm

LABEL maintainer="iedred7584"

RUN cd / && \
  curl -sL http://getcomposer.org/installer | php && \
  ln -s /composer.phar /usr/bin/composer && \
  curl -sL https://deb.nodesource.com/setup_15.x | bash - && \
  apt-get update && \
  apt-get install -y git zip unzip nodejs libpq-dev && \
  docker-php-ext-install pdo_mysql pdo_pgsql

WORKDIR /var/www/html
