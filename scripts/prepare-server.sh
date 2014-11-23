#!/bin/sh

# Settings:
user=navicc
nginx=stable

# Common

# Set the debconf frontend to Noninteractive
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# apt-get install mc gcc python-setuptools -y

# Nginx

add-apt-repository ppa:nginx/$nginx -y
apt-get update
apt-get install nginx -y
service nginx start
update-rc.d nginx defaults

# Cyrillic

# apt-get install language-pack-ru-base
# sudo dpkg-reconfigure locales
# sudo aptitude install console-cyrillic
#
# # Для переконфигурации можно выполнить:
# sudo dpkg-reconfigure console-cyrillic

# useradd -d /home/$user -m $user
# echo "Set password for user $user:"
# passwd $user


# MongoDB

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get install -y mongodb-org
service mongod start
update-rc.d mongod defaults
# TODO: Disable external connection

# Erlang

wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install erlang -y


echo "Copy ssh-key by: ssh-copy-id $user@`hostname`"
echo "If used alternale port, use (quotes is needed): ssh-copy-id '-p 443 user@server'"
