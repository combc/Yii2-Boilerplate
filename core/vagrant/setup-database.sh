#!/usr/bin/env bash

begin=$(date +"%s")

APP_DB_USER=vagrant
APP_DB_PASS=vagrant
APP_DB_NAME=yii2boilerplate
APP_DB_NAME_TESTS=yii2boilerplate_tests


if [ "$1" == "mysql" ]
then
    #MySQL + phpmyadmin
    echo You chose MYSQL
    # Mysql root password
    mysql_root_password=$APP_DB_PASS

    echo "mysql-server-5.6 mysql-server/root_password password $mysql_root_password
    mysql-server-5.6 mysql-server/root_password seen true
    mysql-server-5.6 mysql-server/root_password_again password $mysql_root_password
    mysql-server-5.6 mysql-server/root_password_again seen true
    phpmyadmin phpmyadmin/dbconfig-install boolean true
    phpmyadmin phpmyadmin/app-password-confirm password $APP_DB_PASS
    phpmyadmin phpmyadmin/mysql/admin-pass password $APP_DB_PASS
    phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS
    phpmyadmin phpmyadmin/reconfigure-webserver multiselect none
    " | sudo debconf-set-selections

    #in case it's already installed, we change the password instead
    if [ ! -f /etc/init.d/mysql ]; then
        sudo apt-get install -y mysql-server-5.6 phpmyadmin
    else
        sudo dpkg-reconfigure -f noninteractive mysql-server-5.6 phpmyadmin
    fi
    sudo apt-get install -y php5-mysqlnd  phpmyadmin

    sed -i 's/bind-address = 127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/my.cnf;
    sed -i 's/skip-external-locking/skip-external-locking \
    skip-name-resolve/g' /etc/mysql/my.cnf;

    mysql -uroot --password="$mysql_root_password" -e "CREATE SCHEMA IF NOT EXISTS $APP_DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
    mysql -uroot --password="$mysql_root_password" -e "CREATE SCHEMA IF NOT EXISTS $APP_DB_NAME_TESTS DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
    mysql -uroot --password="$mysql_root_password" -e "GRANT ALL PRIVILEGES ON $APP_DB_NAME.* TO '$APP_DB_USER'@'localhost' IDENTIFIED BY '$APP_DB_PASS' WITH GRANT OPTION;";
    mysql -uroot --password="$mysql_root_password" -e "GRANT ALL PRIVILEGES ON $APP_DB_NAME.* TO '$APP_DB_USER'@'%' IDENTIFIED BY '$APP_DB_PASS' WITH GRANT OPTION;";
    mysql -uroot --password="$mysql_root_password" -e "GRANT ALL PRIVILEGES ON $APP_DB_NAME_TESTS.* TO '$APP_DB_USER'@'localhost' IDENTIFIED BY '$APP_DB_PASS' WITH GRANT OPTION;";
    mysql -uroot --password="$mysql_root_password" -e "GRANT ALL PRIVILEGES ON $APP_DB_NAME_TESTS.* TO '$APP_DB_USER'@'%' IDENTIFIED BY '$APP_DB_PASS' WITH GRANT OPTION;";

    cp /vagrant/core/default-file/main-local-mysql.php /vagrant/common/config/main-local.php 
    cp /vagrant/core/default-file/config-test-mysql.php /vagrant/tests/codeception/config/config.php

    echo "Successfully created MySQL dev virtual machine."
    echo "http://localhost:8080/phpmyadmin/"
    echo ""
elif [ "$1" == "pgsql" ]
then
    #PGSQL
    echo You chose PGSQL

    PG_VERSION=9.3

    export DEBIAN_FRONTEND=noninteractive
    PROVISIONED_ON=/etc/vm_provision_on_timestamp
    if [ -f "$PROVISIONED_ON" ]
    then
    echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
    echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
    echo ""
    exit
    fi
    PG_REPO_APT_SOURCE=/etc/apt/sources.list.d/pgdg.list
    if [ ! -f "$PG_REPO_APT_SOURCE" ]
    then
    # Add PG apt repo:
    echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > "$PG_REPO_APT_SOURCE"
    # Add PGDG repo key:
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
    fi
    # Update package list and upgrade all packages
    apt-get update
    apt-get -y upgrade
    apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"
    PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
    PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
    PG_DIR="/var/lib/postgresql/$PG_VERSION/main"
    # Edit postgresql.conf to change listen address to '*':
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"
    # Append to pg_hba.conf to add password auth:
    echo "host all all all md5" >> "$PG_HBA"
    # Restart so that all new config is loaded:
    service postgresql restart
    cat << EOF | su - postgres -c psql
    -- Create the database user:
    CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
    -- Create the database:
    CREATE DATABASE $APP_DB_NAME WITH OWNER $APP_DB_USER;
    CREATE DATABASE $APP_DB_NAME_TESTS WITH OWNER $APP_DB_USER;
EOF
    # Tag the provision time:
    date > "$PROVISIONED_ON"
    apt-get -y install phppgadmin
    cp  /vagrant/core/phppgadmin.conf /etc/apache2/conf-enabled/phppgadmin.conf


    cp /vagrant/core/default-file/main-local-pgsql.php /vagrant/common/config/main-local.php 
    cp /vagrant/core/default-file/config-test-pgsql.php /vagrant/tests/codeception/config/config.php


    echo "Successfully created PostgreSQL dev virtual machine."
    echo "http://localhost:8080/phppgadmin/"
    echo ""


fi

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "setup-database time $difftimelps" >> /vagrant/core/vagrant-up.log
