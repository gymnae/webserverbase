#
# nginx based mini webserver
# with redis client and php-fpm
#

FROM gymnae/alpine-base:master
MAINTAINER Gunnar Falk <docker@grundstil.de>

# #
# add packages
RUN apk add --no-cache \
	php7-fpm \
	php7-openssl \
	#php7-cli@testing \
	php7-curl \
	php7-fpm \
	php7-gd \
	php7-redis \
	php7-pdo_mysql \
	php7-pgsql \
	libmaxminddb \
	php7-sqlite3 \
        php7-sodium\
	php7-yaml  \
        php7-session  \
        php7-mbstring  \
        php7-json \
        php7-simplexml  \
        php7-ctype  \
        php7-dom  \
        php7-xml  \
        php7-zip \
	php7-opcache \
	php7-apcu \
	php7-exif \
	php7-zlib
	
# forward request and error logs to docker log collector
RUN 	ln -sf /dev/stdout /var/log/php7/access.log \
	&& ln -sf /dev/stderr /var/log/php7/error.log 
#	&& mkdir -p /tmp/nginx \
#	&& chown nginx /tmp/nginx 

# add an nginx user to avoid running as root and manage the mountpoint properly
# we continue using nginx even for php-fpm only to access mounted files
# with the same UID GUID
RUN 	addgroup -S www-data && adduser -S nginx -G www-data
#	&& mkdir -p /var/www/localhost/htdocs \
#	&& chown -R nginx:www-data /var/www/localhost/htdocs

# copy the config
#COPY nginx.conf /etc/nginx/
COPY php-fpm.conf /etc/php7/php-fpm.conf

EXPOSE 80 443 8080 4443
	
VOLUME ["/var/www/localhost/htdocs"]
# run php-fpm
USER nginx
CMD "/usr/sbin/php-fpm7 -F"
