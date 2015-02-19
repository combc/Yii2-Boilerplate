#!/usr/bin/env bash

begin=$(date +"%s")

sudo add-apt-repository ppa:ondrej/php5-5.6
apt-get update

 # Install Apache2
apt-get -y install apache2
apt-get -y install mcrypt
# Install PHP5 support
apt-get install -y apache2-mpm-worker
apt-get install -y php5-common libapache2-mod-php5 php5-apcu php5-gd php5-mcrypt php5-xdebug php5-xsl
apt-get install -y curl php5-curl
apt-get install -y memcached php5-memcache

apt-get install -y git nano

php5enmod mcrypt

#xdebug config
pecl install xdebug

cat << EOT >> /etc/php5/apache2/php.ini
;My change
error_reporting = E_ALL
display_errors = On
display_startup_errors = On
log_errors = On

zend_extension="/usr/lib/php5/20131226/xdebug.so"

xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.idekey="XDEBUG"
xdebug.remote_autostart=0
xdebug.remote_enable=1
xdebug.remote_port=9000
xdebug.remote_handler="dbgp"
xdebug.remote_log="/var/log/xdebug/xdebug.log"
EOT

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "prepare time $difftimelps" >> /vagrant/core/vagrant-up.log