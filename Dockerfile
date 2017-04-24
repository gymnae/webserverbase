#
# nginx based mini webserver
# with redis client and php-fpm
#

FROM gymnae/alpine-base:master
MAINTAINER Gunnar Falk <docker@grundstil.de>

# add packages
RUN apk-install \
	php7-fpm \
	nginx \
	php7-openssl \ 
	php7-cli \
	php7-curl \
	php7-fpm \
	php7-gd \
	php7-mcrypt \
	php7-redis \
	php7-mysql \
	php7-pgsql \
	php7-sqlite3 \
	php7-zlib \
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
COPY php-fpm.conf /etc/php/php-fpm.conf

EXPOSE 80 443 8080 4443 3000 22
	
VOLUME ["/var/www/localhost/htdocs"]

# update npm
CMD npm install npm@latest -g

# make sshd run at boot and start sshd
CMD rc-update add sshd && /etc/init.d/sshd start

# run nginx
CMD /usr/bin/php-fpm ; /usr/sbin/nginx -g "daemon off;"
