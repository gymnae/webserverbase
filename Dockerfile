#
# nginx based mini webserver
# with redis client and php-fpm
#

FROM gymnae/alpine-base:latest
MAINTAINER Gunnar Falk <docker@grundstil.de>

# #
# add packages
RUN apk add --no-cache \
	php8-fpm \
	nginx \
	nginx-mod-http-redis2 \
	nginx-mod-http-upload-progress \
	nginx-mod-http-geoip \
	nginx-mod-http-cache-purge \
	nginx-mod-http-fancyindex \
	nginx-mod-rtmp \
	php81-openssl \
	php81-curl \
	php81-gd \
	php81-pecl-redis \
	php81-pdo_mysql \
	php81-pgsql \
	libmaxminddb \
	php81-sqlite3 
	
# forward request and error logs to docker log collector
RUN 	ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& mkdir -p /tmp/nginx \
	&& chown nginx /tmp/nginx 

# add an nginx user to avoid running as root and manage the mountpoint properly
RUN 	addgroup nginx www-data 
#	&& mkdir -p /var/www/localhost/htdocs \
#	&& chown -R nginx:www-data /var/www/localhost/htdocs

# copy the config
COPY nginx.conf /etc/nginx/
COPY php-fpm.conf /etc/php8/php-fpm.conf

EXPOSE 80 443 8080 4443
	
VOLUME ["/var/www/localhost/htdocs"]
# run nginx
CMD /usr/sbin/php-fpm8 ; /usr/sbin/nginx -g "daemon off;"
USER nginx
