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
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& mkdir -p /tmp/nginx \
	&& chown nginx /tmp/nginx 

# add an nginx user to avoid running as root and manage the mountpoint properly
RUN 	addgroup nginx www-data 
#	&& mkdir -p /var/www/localhost/htdocs \
#	&& chown -R nginx:www-data /var/www/localhost/htdocs

# copy the config
COPY nginx.conf /etc/nginx/
COPY php-fpm.conf /etc/php/php-fpm.conf

EXPOSE 80 443 8080 4443
	
VOLUME ["/var/www/localhost/htdocs"]
# run nginx
CMD ["php-fpm" "&&" "nginx", "-g", "daemon off;"]
