#!/bin/bash
#  добавления из официального репозитория Zabbix в список apt.  распакуем и сразу же обновим список репозиториев
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1+ubuntu20.04_all.deb 
dpkg -i zabbix-release_6.0-1+ubuntu20.04_all.deb 
apt update 
# ставим дополнительные модули для работы потсгрес,nginx,php
yes | apt install zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

#устанавливаем сервер баз данных, создаём пользователя zabbix и таблицу zabbix
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list

sudo apt update

yes | sudo apt install postgresql-13
#вводим пароль потом его нужно будет ввести в конфиг заббикса /etc/zabbix/zabbix_server.conf 
sudo -u postgres createuser --pwprompt zabbix 

sudo -u postgres createdb -O zabbix zabbix

zcat /usr/share/doc/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

#ниже строка копирует мой конфиг , но в гит я этот файл не положил, т.е. при выполнении скрипта он должен рядом быть . или руками правим 
cp nginx.conf /etc/zabbix/
# что апач нам не помешал и не забил 80 порт, т.к. на всякий случай)
yes | sudo apt remove apache2

# перезапуск заббикса
systemctl restart zabbix-server zabbix-agent nginx php7.4-fpm

systemctl enable zabbix-server zabbix-agent nginx php7.4-fpm
