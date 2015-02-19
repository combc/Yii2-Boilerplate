#!/bin/sh -e 
begin=$(date +"%s")
# install mailcatcher
apt-get install -y build-essential software-properties-common
apt-get install -y libsqlite3-dev ruby1.9.1-dev

gem install mailcatcher


su vagrant -l -c "echo 'sendmail_path = /usr/bin/env $(which catchmail) -f yii2mail@local.dev'" | tee /etc/php5/mods-available/mailcatcher.ini
php5enmod mailcatcher
service apache2 restart

mailcatcher --ip=0.0.0.0

echo "Successfully created Mailcatcher dev virtual machine."
echo "http://0.0.0.0:1081/"
echo ""

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "setup-mailcatcher time $difftimelps" >> /vagrant/core/vagrant-up.log