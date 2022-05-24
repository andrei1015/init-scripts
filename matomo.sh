#!/bin/bash

mkdir /home/arch/matomo-zip

wget https://builds.matomo.org/matomo.zip
unzip -o matomo.zip -d /home/arch/matomo-zip
sudo rm -rf /srv/http/*
sudo mv /home/arch/matomo-zip/matomo/* /srv/http
rm -rf /home/arch/matomo-zip
sudo chown -R http:http /srv/http
sudo systemctl restart httpd

sudo mariadb < /home/arch/init-scripts/files/matomo.sql
rm /srv/http/config/config.php.ini
cp /home/arch/init-scripts/files/matomo-config.php.ini /srv/http/config/config.php.ini

rm -rf /home/arch/matomo
