# Pimcore Vagrant
Vagrant for Pimcore 5

## Machine contains
- PHP 7.2
- MySQL
- Apache
- Redis

## Getting Started
### Requirements
- [Vagrant](https://www.vagrantup.com)
- [VirtuaBox](https://www.virtualbox.org)

## Installation
Setup Vagrant Box
```bash
vagrant up
```

Create a new project
```bash
vagrant ssh

cd /var/www

COMPOSER_MEMORY_LIMIT=-1 composer create-project pimcore/skeleton:dev-master pimcore

cd pimcore

./vendor/bin/pimcore-install --mysql-host-socket=db --mysql-username=root --mysql-password=root --mysql-database=pimcore
```

Add project to host
```bash
sudo vim /etc/hosts
```
```
192.168.10.10 pimcore.local
```

## Access Remote Database
- Host: *192.168.10.10*
- Port: *3306*
- Username: *pimcore*
- Password: *pimcore*
- Databse: *pimcore*

## Fix Session
Copy the `.provision/configs/session.yml` file to `pimcore/app/config/local/configs/session.yml`

## Usage
- Frontend: [pimcore.local](http://pimcore.local)
- Backend: [pimcore.local/admin](http://pimcore.local/admin)
