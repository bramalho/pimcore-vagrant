#!/bin/bash

DB_USER=root
DB_PASSWORD=root

echo "Setting up your Vagrant"

echo "Updating..."
sudo apt-get update

# Apache
echo "Installing Apache..."
sudo apt-get install -y apache2 apache2-doc apache2-utils debconf-utils htop mc 
sudo rm /etc/apache2/sites-enabled/000-default.conf

sudo a2enmod rewrite 

# PHP and components
echo "Installing PHP and components..."
sudo apt-get install -y imagemagick php-imagick ffmpeg
sudo apt-get install -y php-bz2 php7.2-intl php7.2 libapache2-mod-php7.2 php7.2-mysql
sudo apt-get install -y zip unzip php7.2-zip php7.2-curl composer
sudo apt-get install -y redis-server php-redis npm htop mc
sudo apt-get install -y php7.2-mbstring php7.2-xml
sudo apt-get install -y php7.2-gd php7.2-intl php7.2-xsl

# Apache Config
echo "Configuring Apache..."
cp /vagrant/.provision/apache/pimcore /etc/apache2/sites-available/pimcore.conf 
sudo ln -s /etc/apache2/sites-available/pimcore.conf /etc/apache2/sites-enabled/pimcore.conf  

sudo service apache2 restart 

echo "ubuntu:vagrant" | chpasswd

sudo rm -r /var/www/html

# MySQL
echo "Installing MySQL..."
cp /vagrant/.provision/mysql/my.cnf /home/vagrant/.my.cnf 

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_PASSWORD"

sudo apt-get install -y mysql-server

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
mysql --defaults-extra-file=/home/vagrant/.my.cnf -e"GRANT ALL ON *.* TO 'pimcore'@'%' IDENTIFIED BY 'pimcore' WITH GRANT OPTION;"

echo "Creating database..."
mysql --defaults-extra-file=/home/vagrant/.my.cnf -e"CREATE DATABASE pimcore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql --defaults-extra-file=/home/vagrant/.my.cnf -e"GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'*' IDENTIFIED BY '$DB_PASSWORD' WITH GRANT OPTION;"
mysql --defaults-extra-file=/home/vagrant/.my.cnf -e"GRANT FILE ON *.* TO '$DB_USER'@'*';"
mysql --defaults-extra-file=/home/vagrant/.my.cnf -e"FLUSH PRIVILEGES;"

echo '[mysqld]' >> /etc/mysql/my.cnf
echo 'secure-file-priv = ""' >> /etc/mysql/my.cnf

sudo service mysql restart

echo "Increasing memory limits..."
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024 
sudo chmod 0600 /var/swap.1 
sudo /sbin/mkswap /var/swap.1 
sudo /sbin/swapon /var/swap.1 

echo "Changing permissions..."
sudo chmod 777 -R /var/www/

echo "Done!"
