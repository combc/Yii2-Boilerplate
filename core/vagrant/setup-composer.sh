#!/bin/sh -e 
begin=$(date +"%s")

# install composer
if [ ! -f /usr/local/bin/composer ]; then
    sudo curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
else
    sudo composer self-update
fi
echo "Your github token: $1";
su vagrant -l -c "composer config -g github-oauth.github.com $1"
su vagrant -l -c 'composer global require "fxp/composer-asset-plugin:1.0.*@dev"'
su vagrant -l -c 'composer global require "codeception/codeception=2.0.*" "codeception/specify=*" "codeception/verify=*"'

su vagrant -l -c "cd /vagrant/ && composer install --no-interaction"
su vagrant -l -c "composer global require 'sebastian/phpdcd=*'"
su vagrant -l -c "composer global require 'phpmd/phpmd=@stable'"
su vagrant -l -c "composer global require 'squizlabs/php_codesniffer=*'"
su vagrant -l -c "composer global require 'sebastian/phpcpd=*'"
su vagrant -l -c "composer global require 'theseer/phpdox=*'"

ln -s /home/vagrant/.composer/vendor/bin/codecept /usr/local/bin/codecept
ln -s /home/vagrant/.composer/vendor/bin/phpdcd /usr/local/bin/phpdcd
ln -s /home/vagrant/.composer/vendor/bin/phpmd /usr/local/bin/phpmd
ln -s /home/vagrant/.composer/vendor/bin/phpcs /usr/local/bin/phpcs
ln -s /home/vagrant/.composer/vendor/bin/phpcbf /usr/local/bin/phpcbf
ln -s /home/vagrant/.composer/vendor/bin/phpcpd /usr/local/bin/phpcpd
ln -s /home/vagrant/.composer/vendor/bin/phpdox /usr/local/bin/phpdox



echo "Successfully install Composer dev virtual machine."
echo ""

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "setup-composer time $difftimelps" >> /vagrant/core/vagrant-up.log


