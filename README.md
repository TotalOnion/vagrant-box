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

#### Configuration

`vagrant/config/vagrant-local.yml` contains configuration parameters for the script.

`vagrant/provision/once-as-vagrant.sh` contains commands for post install updates including running `composer install`
or `npm install` etc.


#### Working Directory
The working directory of the box is `/app` not `/vagrant`

#### Database
The default IP for the database is: `192.168.83.138`. This is configurable in `vagrant/config/vagrant-local.yml`.
The password for `root` is set to `root`.







