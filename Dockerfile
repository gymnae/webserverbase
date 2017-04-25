#
# nginx based mini webserver
# with redis client and php-fpm
#

FROM gymnae/alpine-base:master
MAINTAINER Gunnar Falk <docker@grundstil.de>

# add packages
RUN apk-install \
	php7-fpm@testing \
	nginx \
	php7-openssl@testing \ 
	#php7-cli@testing \
	php7-curl@testing \
	php7-fpm@testing \
	php7-gd@testing \
	php7-mcrypt@testing \
	php7-redis@testing \
	php7-pdo_mysql@testing \
	php7-pgsql@testing \
	php7-sqlite3@testing \
	php7-zlib@testing \
	nodejs \
	nodejs-npm \
	git
	
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
COPY php-fpm.conf /etc/php7/php-fpm.conf

EXPOSE 80 443 8080 4443 3000 22 3001
	
VOLUME ["/var/www/localhost/htdocs"]

# update npm
CMD npm install npm@latest -g

# run nginx
CMD /usr/bin/php-fpm7 ; /usr/sbin/nginx -g "daemon off;"
