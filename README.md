# Yii2Boilerplate
Structure for enterprise-grade websites for Yii2 framework.

## Easiest initial deploy ever
1.  Install [Vagrant][vagrant].

2.  Install [Virtualbox][virtualbox].

3.  If you have PHP 5.4+ installed already, you've just installed all prequisites for YiiBoilerplate.

4.  Now just clone the Yii2Boilerplate repo:

        git clone git@github.com/combc/Yii2Boilerplate.git <yourprojectname>

5.  Create your own github personal API tokens [https://github.com/blog/1509-personal-api-tokens](https://github.com/blog/1509-personal-api-tokens). Paste it into a Vagrantfile.

    Example: 
    
        s.args   = [
           #YOUR GITHUB TOKEN HERE
           "d1d8c6a9e9b706a596b96b9994bf0549109083ba",
           ...
        ]
    
    Note: [Yii2Install][yiiinstall]

6.  Inside cloned directory run and wait for complete:

        vagrant up

7.  You're done. Open up the [http://yii2frontend.dev:8080/](http://yii2frontend.dev:8080/). It's your future frontend. Open up [http://yii2backend.dev:8080/](http://yii2backend.dev:8080/). It's your future backend. You can start working.
8. Change the origin repo to the new repository in order to push your new project:

        git remote remove origin  
        git remote add origin <NEW-GIT-REMOTE>

    Don't forget to `vagrant halt` the virtual machine before turning off your workstation, virtualbox can fail to shut itself down in time before `kill -9` arrives.

## Yii 2 Advanced Application Template
Yii2Boilerplate uses [Yii 2 Advanced Application Template][yii2template] is a skeleton Yii 2 application best for developing complex Web applications with multiple tiers.

## Vagrant config

### Database

You can select up data between [MySQL 5.6][mysql] and [Postgres 9.3][pgsql]. Enter the Vagrantfile name of the database, default mysql.

Example:

        s.args   = [
            ...
            #YOUR DATABASE TYPE HERE [mysql|pgsql]
            "pgsql"
        ]

If you have chosen MySQL:

PhpMyAdmin adress: [http://localhost:8080/phpmyadmin/](http://localhost:8080/phpmyadmin/)

If you have chosen Postgres:

PhpPgAdmin adress: [http://localhost:8080/phppgadmin/](http://localhost:8080/phppgadmin/)

#### Database default credential:

login: vagrant

password: vagrant

database: yii2boilerplate

database for tests: yii2boilerplate_tests

### MailCatcher
[MailCatcher][mailcatcher] runs a super simple SMTP server which catches any message sent to it to display in a web interface.

[smtp://0.0.0.0:1026](smtp://0.0.0.0:1026)

[http://0.0.0.0:1081](http://0.0.0.0:1081)

Default common/config/main-local.php:

        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            'viewPath' => '@common/mail',
            'useFileTransport' => false,
        ],

### Virtual Machine config

Use the vagrantfile to the desired options of memory and cpu. 

DEFAULT: memory = 1024 MB, cpus = 2

        config.vm.provider "virtualbox" do |v|
                #v.memory = 512
                #v.cpus = 1
    
                v.memory = 1024
                v.cpus = 2
        end
More [http://docs.vagrantup.com/v2/virtualbox/configuration.html](http://docs.vagrantup.com/v2/virtualbox/configuration.html)

### XDebug conf

XDebug SessionId: XDEBUG

XDebug port 9000

#### On run configuration:

        Project URL: http://yii2backend.dev:8080/
        Index file: backend/web/index.php
        
        or
        
        Project URL: http://yii2frontend.dev:8080/
        Index file: backend/web/index.php


### The installed
* [Ubuntu 14.04][ubuntu]
* [Apache 2.4][apache]
* [PHP 5.6][php]
* [Composer][composer]

        composer 
        
* [Coceception][coceception]
 
        codecept

* [PHP Dead Code Detector][phpdcd], 
 
        phpdcd 

* [PHP Mess Detector][phpmd],
 
        phpmd
        
* [PHP_CodeSniffer][phpcs],

        phpcs 

* [PHP Copy/Paste Detector][phpcpd],

        phpcpd 

* [PHP Documentation Generator][phpdox],
 
        phpdox

### License

And of course:

MIT: [LICENCE][licence]

====

> ComBC   
[http://combc.eu](http://combc.eu)


[ubuntu]: http://releases.ubuntu.com/14.04/
[yii]: http://www.yiiframework.com/
[yiiinstall]: http://www.yiiframework.com/doc-2.0/guide-start-installation.html
[vagrant]: http://docs.vagrantup.com/v2/getting-started/
[virtualbox]: https://www.virtualbox.org/
[mysql]: http://www.mysql.com/
[pgsql]: http://www.postgresql.org/
[mailcatcher]: http://mailcatcher.me/
[yii2template]: https://github.com/yiisoft/yii2-app-advanced
[apache]: http://www.apache.org/
[php]: http://php.net/
[composer]: https://getcomposer.org/
[Coceception]: http://codeception.com/
[phpdcd]: https://github.com/sebastianbergmann/phpdcd
[phpmd]: http://phpmd.org/
[phpcs]: https://github.com/squizlabs/PHP_CodeSniffer
[phpdox]: http://phpdox.de/
[phpcpd]: https://github.com/sebastianbergmann/phpcpd
[licence]: ../master/LICENSE.md
