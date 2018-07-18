#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")
dbname = $(echo "$2")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo "--> $2"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

export DEBIAN_FRONTEND=noninteractive

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Prepare root password for MySQL"
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password root"
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password root"
echo "Done!"

info "Update OS software"
apt-get update
apt-get upgrade -y

apt-get install software-properties-common
add-apt-repository ppa:ondrej/php
apt-get update

info "Install additional software"
apt-get -y install mysql-server
usermod -a -G vagrant www-data
apt-get install -y mysql-server
# apt-get install -y nginx
apt-get install -y apache2
apt-get install -y memcached
apt-get install language-pack-en
apt-get install git
apt-get install -y autoconf g++ make openssl
apt-get install -y libssl-dev
apt-get install -y libcurl4-openssl-dev
apt-get install -y pkg-config
apt-get install -y libsasl2-dev
apt-get install -y libsslcommon2-dev
apt-get install unzip
apt-get -y install php libapache2-mod-fastcgi php7.1-dev php7.1-zip php7.1-mcrypt php7.1-mysql php7.1-curl php7.1-gd php7.1-intl php-pear php-imagick php7.1-imap php7.1-mcrypt php-memcache  php7.1-pspell php7.1-recode php7.1-sqlite3 php7.1-tidy php7.1-xmlrpc php7.1-xsl php7.1-mbstring php-gettext php7.1-bcmath php7.1-gmp php7.1-dev php.xdebug
apt-get -y install php7.1-fpm

info "Configure MySQL"
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -uroot <<< "CREATE USER 'root'@'%' IDENTIFIED BY ''"
mysql -uroot <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'"
mysql -uroot <<< "DROP USER 'root'@'localhost'"
mysql -uroot <<< "FLUSH PRIVILEGES"
echo "Done!"

info "Configure PHP-FPM"
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/owner = www-data/owner = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
cat << EOF > /etc/php/7.1/mods-available/xdebug.ini
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_autostart=1
EOF
echo "Done!"

echo "Installing Node/NPM"
apt-get install -y nodejs
apt-get install -y npm
echo "Done installing Node/NPM"

#info "Configure NGINX"
#sed -i 's/user www-data/user vagrant/g' /etc/nginx/nginx.conf
#echo "Done!"
#
#info "Enabling site configuration"
#ln -s /app/vagrant/nginx/app.conf /etc/nginx/sites-enabled/app.conf
#echo "Done!"

info "Configure APACHE2"
sed -i 's/user www-data/user vagrant/g' /etc/apache2/apache2.conf
echo "Done!"

info "Enabling site configuration"
ln -s /app/vagrant/apache2/apache.conf /etc/apache2/sites-enabled/app.conf
a2dissite 000-default.conf
a2enmod rewrite
a2enmod actions fastcgi alias
a2ensite app.conf
echo "Done!"

info "Initailize databases for MySQL"
mysql -uroot <<< "CREATE DATABASE $db_name"
echo "Done!"

info "Install composer"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer