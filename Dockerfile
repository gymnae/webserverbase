#
# nginx based mini webserver
# with redis client and php-fpm
#

FROM gymnae/alpine-base

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
	php-mysql \
	php-pgsql \
	php-redis@testing \
	php-sqlite3 \
	php-zlib 
	
# add an nginx user to avoid running as root
RUN addgroup nginx www-data

