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

##copy ignore file
cp /vagrant/core/default-file/params-local.php /vagrant/common/config/params-local.php 
cp /vagrant/core/default-file/params-local.php /vagrant/console/config/params-local.php 
cp /vagrant/core/default-file/params-local.php /vagrant/frontend/config/params-local.php
cp /vagrant/core/default-file/params-local.php /vagrant/backend/config/params-local.php

cp /vagrant/core/default-file/main-local-test.php /vagrant/console/config/main-local.php
cp /vagrant/core/default-file/main-local.php /vagrant/backend/config/main-local.php
cp /vagrant/core/default-file/main-local.php /vagrant/frontend/config/main-local.php

cp /vagrant/core/default-file/index-test.php /vagrant/frontend/web/index-test.php
cp /vagrant/core/default-file/index-test.php /vagrant/backend/web/index-test.php
cp /vagrant/core/default-file/index.php /vagrant/frontend/web/index.php
cp /vagrant/core/default-file/index.php /vagrant/backend/web/index.php

/vagrant/core/vagrant/prepare-trusty64.sh
/vagrant/core/vagrant/setup-database.sh $2
/vagrant/core/vagrant/setup-composer.sh $1
/vagrant/core/vagrant/setup-app.sh
/vagrant/core/vagrant/setup-mailcatcher.sh