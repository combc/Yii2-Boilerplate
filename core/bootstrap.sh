#!/bin/sh -e 

echo Welcome Yii2Boilerplate
echo Composer token: $1
echo Database: $2

if [ -z "$1" ]
  then
    echo ""
    echo "No github token supplied!!!"
    echo "Please vagrant destroy and supply github token on Vagrantfile"
    echo ""
    exit;
fi

apt-get update > /dev/null
apt-get -y install curl

res=$( curl -w %{http_code} https://api.github.com/user?access_token=$1 -s --output /dev/null)
if [ "$res" != "200" ]; then    
    echo ""
    echo "Wrong github token supplied!!!"
    echo "Please change github token on Vagrantfile"
    echo ""
    exit;
fi


if [ "$2" != "mysql" ] && [ "$2" != "pgsql" ]
then
    echo ""
    echo Only mysql or pgsql database
    echo ""
    exit
fi

/vagrant/core/vagrant/prepare-trusty64.sh
/vagrant/core/vagrant/setup-composer.sh $1

##copy ignore file
cp /vagrant/core/default-file/main-local-test.php /vagrant/console/config/main-local.php
cp /vagrant/core/default-file/main-local.php /vagrant/backend/config/main-local.php
cp /vagrant/core/default-file/main-local.php /vagrant/frontend/config/main-local.php

/vagrant/core/vagrant/setup-database.sh $2
/vagrant/core/vagrant/setup-app.sh
/vagrant/core/vagrant/setup-mailcatcher.sh
