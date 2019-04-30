FROM tetraweb/php

MAINTAINER Daniel Crump <d.crump@taenzer.me>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get dist-upgrade -y
RUN apt-get install openssh-client -y
RUN apt-get install -y zlib1g-dev

ENV NVM_DIR /usr/local/bin
ENV NODE_VERSION 10.4.0

RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-enable intl

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
