Overview
--

This box is a base LAMP stack.

The stack includes:
1. Ubuntu 16.04 (bento)
2. Apache 2 (php-fpm)
3. MySQL Server
4. PHP 7.1
5. Memcached
6. Node/NPM
7. Composer


** Nginx

If you would prefer to use Nginx, edit `vagrant/provision/once-as-root.sh` and un-comment the lines relevant to Nginx. Be
sure to comment the lines related to Apache.

#### Configuration & Setup

1. Copy `vagrant/config/vagrant-local.example.yml` to `vagrant/config/vagrant-local.yml`.
2. Add your github token and customise any other setting.
3. Run `vagrant up`.

`vagrant/provision/once-as-vagrant.sh` contains commands for post install updates including running `composer install`
or `npm install` etc. This is executed during `vagrant up --provision` but can be executed from within the vagrant box 
if you would like to run the install scripts without re-building the box.


#### Working Directory
The working directory of the box is `/app` not `/vagrant`

#### Database
The default IP for the database is: `192.168.83.138`. This is configurable in `vagrant/config/vagrant-local.yml`.
The password for `root` is set to `root`.







