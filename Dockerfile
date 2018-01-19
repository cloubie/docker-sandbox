FROM alexcheng/apache2-php7:7.1.11

MAINTAINER Cédric Loubié <cloubie@siliconsalad.com>

RUN a2enmod rewrite

ENV MYSQL_HOST db
ENV MYSQL_ROOT_PASSWORD myrootpassword
ENV MYSQL_USER magento
ENV MYSQL_PASSWORD magento
ENV MYSQL_DATABASE magento
ENV MAGENTO_LANGUAGE fr_FR
ENV MAGENTO_TIMEZONE Europe/Paris
ENV MAGENTO_DEFAULT_CURRENCY EUR
ENV MAGENTO_URL http://local.magento
ENV MAGENTO_ADMIN_FIRSTNAME Admin
ENV MAGENTO_ADMIN_LASTNAME MyStore
ENV MAGENTO_ADMIN_EMAIL admin@example.com
ENV MAGENTO_ADMIN_USERNAME admin
ENV MAGENTO_ADMIN_PASSWORD magent0
ENV MAGENTO_PROJECT_PATH ""

RUN rm -rf /var/www/html/* \
    && apt-get update \
    && apt-get install -y wget

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN requirements="libpng12-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg-turbo8 libjpeg-turbo8-dev libpng12-dev libfreetype6-dev libicu-dev libxslt1-dev" \
    && apt-get install -y $requirements \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && requirementsToRemove="libpng12-dev libmcrypt-dev libcurl3-dev libpng12-dev libfreetype6-dev libjpeg-turbo8-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

RUN echo "memory_limit=1024M" > /usr/local/etc/php/conf.d/memory-limit.ini

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/html