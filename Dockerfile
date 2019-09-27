FROM php:7.3
LABEL maintainer="bgrzyb@blomu.pl"

# Install deps
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    git \
    zip \
    unzip \
    libzip-dev \
    python-pip \
    python2.7-dev \
    groff-base \
    build-essential \
    libicu-dev \
    apt-utils \
    --no-install-recommends

RUN apt-get install -y locales

RUN docker-php-ext-install mbstring

# Install zip
RUN docker-php-ext-install zip

# Install ext-intl
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

# Install aws cli
RUN pip install --upgrade pip setuptools
RUN pip install --upgrade awscli

# Install opcache
RUN docker-php-ext-install opcache

# Install APCu
RUN pecl install apcu
RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini

# Install Xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Get Chrome sources
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Install Chrome
RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends

# Get yarn sources
RUN curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb [arch=amd64] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Install yarn pinned version
RUN apt-get update && apt-get install -y \
    yarn=1.6.0-1 \
    --no-install-recommends

# Find your desired version here: https://deb.nodesource.com/node_10.x/pool/main/n/nodejs/
# Ubuntu 16.04.3 LTS (Xenial Xerus) (https://wiki.ubuntu.com/Releases)
RUN curl https://deb.nodesource.com/node_10.x/pool/main/n/nodejs/nodejs_10.0.0-1nodesource1_amd64.deb > node.deb \
 && dpkg -i node.deb \
 && rm node.deb
 
# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer  
