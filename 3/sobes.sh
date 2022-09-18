#!/bin/bash
sudo su
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1+ubuntu20.04_all.deb
dpkg -i zabbix-release_6.0-1+ubuntu20.04_all.deb
apt update
yes | apt install zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list

sudo apt update

yes | sudo apt install postgresql-13

sudo -u postgres createuser --pwprompt zabbix #вводим пароль

sudo -u postgres createdb -O zabbix zabbix

zcat /usr/share/doc/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix


cp nginx.conf /etc/zabbix/

yes | sudo apt remove apache2

systemctl restart zabbix-server zabbix-agent nginx php7.4-fpm

systemctl enable zabbix-server zabbix-agent nginx php7.4-fpm
