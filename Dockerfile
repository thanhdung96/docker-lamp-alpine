FROM alpine:latest

# metadata
LABEL maintainer="Dung DUONG"
LABEL email="duduong96@outlook.com"
LABEL description="minimalist LAP (Linux Apache PHP) stack runs on alpine linux"

# docker variables
ENV DOCKER_USER_ID=501 
ENV DOCKER_USER_GID=20
ENV BOOT2DOCKER_ID=1000
ENV BOOT2DOCKER_GID=50

# build args
ARG PHP_VERSION
ENV PHP_VERSION=$PHP_VERSION
ARG TIMEZONE="Asia/Ho_Chi_Minh"
ENV TIMEZONE=$TIMEZONE
ARG DOCUMENTROOT="/"
ENV DOCUMENTROOT=$DOCUMENTROOT

# install required packages
RUN apk update && apk upgrade
RUN apk add \
    apache2 \ 
    apache2-utils \
    curl wget \
    tzdata \
    php${PHP_VERSION}-apache2 \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-zlib \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-pecl-mcrypt \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-apcu \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-sodium \
    composer

# configure timezone, apache
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
RUN echo "${TIMEZONE}" > /etc/timezone
RUN mkdir -p /run/apache2 && chown -R apache:apache /run/apache2 && chown -R apache:apache /var/www/localhost/htdocs/
RUN sed -i 's#\#LoadModule rewrite_module modules\/mod_rewrite.so#LoadModule rewrite_module modules\/mod_rewrite.so#' /etc/apache2/httpd.conf
RUN sed -i 's#ServerName www.example.com:80#\nServerName localhost:80#' /etc/apache2/httpd.conf
RUN sed -i "s#DocumentRoot \"/var/www/localhost/htdocs\"#\nDocumentRoot /var/www/localhost/htdocs${DOCUMENTROOT}#" /etc/apache2/httpd.conf
RUN sed -i "s#<Directory \"/var/www/localhost/htdocs\">#\n<Directory /var/www/localhost/htdocs${DOCUMENTROOT}>#" /etc/apache2/httpd.conf

# configure php and extensions
RUN sed -i 's#display_errors = Off#display_errors = On#' /etc/php${PHP_VERSION}/php.ini
RUN sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 100M#' /etc/php${PHP_VERSION}/php.ini
RUN sed -i 's#post_max_size = 8M#post_max_size = 100M#' /etc/php${PHP_VERSION}/php.ini
RUN sed -i 's#session.cookie_httponly =#session.cookie_httponly = true#' /etc/php${PHP_VERSION}/php.ini
RUN sed -i 's#error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT#error_reporting = E_ALL#' /etc/php${PHP_VERSION}/php.ini
RUN sed -i 's#;extension=sodium#extension=sodium#' /etc/php${PHP_VERSION}/php.ini

COPY entry.sh /entry.sh
RUN chmod u+x /entry.sh

# Configure /app folder with sample app
RUN mkdir -p /app${DOCUMENTROOT}
RUN rm -fr /var/www/localhost/htdocs
RUN ln -s /app /var/www/localhost/htdocs
ADD ./app/ /app
WORKDIR /app

VOLUME  ["/app"]
EXPOSE 80

ENTRYPOINT ["/entry.sh"]
