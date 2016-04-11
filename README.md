# webserverbase
Minimal Alpine based web server fragment with nginx &amp; php-fpm

mount data:
rocker run [...] -v <path/to/ORdockervolume>:var/www/localhost/htdocs gymnae/webserverbase
