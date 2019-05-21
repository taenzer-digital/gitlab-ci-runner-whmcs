FROM php:7.3

LABEL maintainer="d.crump@taenzer.me"

RUN echo "Europe/Berlin" > /etc/timezone

ENV IMAGE_USER=root
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer
ENV PATH=$HOME/.yarn/bin:$PATH
ENV PHP_VERSION=7.3

USER root

WORKDIR /tmp

COPY --from=composer:1 /usr/bin/composer /usr/bin/composer
COPY ./scripts/*.sh /tmp/
RUN chmod +x /tmp/*.sh

# Install2
RUN bash ./packages.sh \
  && bash ./extensions.sh \
  && bash ./node.sh \
  echo "PATH=$(yarn global bin):$PATH" >> /root/.profile && \
  echo "PATH=$(yarn global bin):$PATH" >> /root/.bashrc && \
  mkdir -p /var/www/html \
  && rm -rf ~/.composer/cache/* \
  && bash ./cleanup.sh \
  && mkdir -p ~/.ssh \

WORKDIR /var/www/html
