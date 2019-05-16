FROM ubuntu:latest

MAINTAINER Daniel Crump <d.crump@taenzer.me>


RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Europe/Berlin" > /etc/timezone

RUN apt-get clean && \
    apt-get update && \
    apt-get dist-upgrade -y

RUN apt-get install -y \
    software-properties-common \
    language-pack-en-base \
    imagemagick \
    rsync  \
    openssh-client \
    curl \
    libmcrypt-dev \
    libreadline-dev \
    libicu-dev \
    build-essential \
    libssl-dev \
    ftp-upload \
    git \
    unzip

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && \
    apt-get install -y \
    php7.3 \
    php7.3-cli \
    php7.3-imagick \
    php7.3-intl \
    php7.3-apcu \
    php7.3-mysql \
    php7.3-mysqli \
    php7.3-pdo \
    php7.3-pdo-mysql \
    php7.3-curl \
    php7.3-gd \
    php7.3-zip \
    php7.3-json \
    php7.3-xml \
    php7.3-intl \
    php7.3-mbstring


# Composer 
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.8.5

RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer \
  && php -r " \
      \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
      \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
      if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
      }" \
  && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
  && composer --ansi --version --no-interaction \
  && rm -f /tmp/installer.php \
  && find /tmp -type d -exec chmod -v 1777 {} +

RUN apt-get install -y ftp yarn nodejs

ENV NVM_DIR /usr/local/bin
ENV NODE_VERSION 10.4.0

# XDEBUG
RUN apt-get install php-xdebug -y

# Run composer update.
RUN composer --version && \
    composer selfupdate

# get nvm
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install -g webpack

RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v), php: $(php -v)"

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
