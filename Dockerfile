FROM php:7.3

LABEL maintainer="d.crump@taenzer.me"

RUN echo "Europe/Berlin" > /etc/timezone

ENV PATH=$HOME/.yarn/bin:$PATH
ENV PHP_VERSION=7.3

ENV DEBIAN_FRONTEND=noninteractive

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
  && chmod 700 ~/.ssh \
  && touch ~/.ssh/config \
  && touch ~/.ssh/known_hosts

WORKDIR /var/www/html
