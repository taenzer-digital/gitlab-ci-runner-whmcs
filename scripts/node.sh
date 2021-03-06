#!/usr/bin/env bash

set -euf -o pipefail

# NODE JS
curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install nodejs -yqq \
    && npm i -g npm \
    && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && npm cache clean --force