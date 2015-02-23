#!/bin/sh -e 
begin=$(date +"%s")

ip=$(echo '127.0.0.1')
# Project file
folder=$(echo '/vagrant')
# Domain to use
frontend_domain=$(echo "yii2frontend.dev")
# Domain to use in admin
backend_domain=$(echo "yii2backend.dev")

# ------- Apache2 -------

# enable apache required modules
sudo a2enmod rewrite actions alias
# default conf adds server name
if [ ! -f /etc/apache2/conf-available/default.conf ]; then
echo "ServerName localhost" > /etc/apache2/conf-available/default.conf
fi
sudo a2enconf default

#Database migration
chmod +x /vagrant/tests/codeception/bin/yii
/vagrant/yii migrate --interactive=0
/vagrant/tests/codeception/bin/yii migrate --interactive=0


############## APACHE ################
# setup hosts file
VHOST=$(cat <<EOF
# Frontend configuration
<VirtualHost *:80>
    DocumentRoot $folder/frontend/web
    ServerName $frontend_domain
    ServerAlias www.$frontend_domain
    <Directory $folder/frontend/web>
        Options All
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
# Backend
<VirtualHost *:80>
    DocumentRoot $folder/backend/web
    ServerName $backend_domain
    <Directory $folder/backend/web>
        Options All
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > "/etc/apache2/sites-available/yii2boilerplate.conf"
# server ports
if ! grep -q "Listen 80" /etc/apache2/ports.conf; then
echo "Listen 80" >> /etc/apache2/ports.conf
fi
# tell apache to use sites vhost file and configs
sudo a2ensite "yii2boilerplate"
# Run Apache as Vagrant user
echo "
# Run Apache as Vagrant user
export APACHE_RUN_USER=vagrant" >> /etc/apache2/envvars
# restart services using new config
sudo service apache2 restart

echo "Successfully setup dev virtual machine."
echo "http://yii2frontend.dev:8080"
echo "http://yii2backend.dev:8080"
echo ""

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "setup-app time $difftimelps" >> /vagrant/core/vagrant-up.log
