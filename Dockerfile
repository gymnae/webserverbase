#
# nginx based mini webserver
# with redis client and php-fpm
#

FROM gymnae/alpine-base
MAINTAINER Gunnar Falk <docker@grundstil.de>

# add packages
RUN apk-install \
	php5-fpm \
	nginx \
	php5-openssl \ 
	php5-cli \
	php5-curl \
	php5-fpm \
	php5-gd \
	php5-mcrypt \
	php5-redis@testing \
	php5-mysql \
	php5-pgsql \
	php5-sqlite3 \
	php5-zlib \
	vsftpd
	
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
CMD /usr/bin/php-fpm ; /usr/sbin/nginx -g "daemon off;" ; init.sh
