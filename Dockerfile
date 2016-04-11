#
# nginx based mini webserver
# with redis client and php-fpm
#

FROM gymnae/alpine-base
MAINTAINER Gunnar Falk <docker@grundstil.de>

# add packages
RUN apk-install \
	php-fpm \
	nginx \
	php-openssl \ 
	php-cli \
	php-curl \
	php-fpm \
	php-gd \
	php-mcrypt \
	php-redis@testing \
	php-mysql \
	php-pgsql \
	php-sqlite3 \
	php-zlib 
	
# forward request and error logs to docker log collector
RUN 	ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# add an nginx user to avoid running as root
RUN 	addgroup nginx www-data
RUN	&& chown -R nginx:www-data /var/www/localhost/htdocs \
	&& chmod 755 /var/www/localhost/htdocs 

USER nginx
VOLUME ["/var/www/localhost/htdocs"]

# run nginx
CMD ["nginx", "-g", "daemon off;"]
