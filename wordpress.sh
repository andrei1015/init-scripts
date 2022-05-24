#!/bin/bash

mkdir /home/arch/wordpress-zip
wget https://wordpress.org/latest.zip

unzip -o latest.zip -d /home/arch/wordpress-zip

sudo rm -rf /srv/http/*
sudo mv /home/arch/wordpress-zip/wordpress/* /srv/http
rm -rf /home/arch/wordpress-zip
sudo chown -R http:http /srv/http
sudo systemctl restart httpd

sudo mariadb < /home/arch/init-scripts/files/wordpress.sql
rm /srv/http/wp-config.php
mv /home/arch/init-scripts/files/wordpress-config.php /srv/http/wp-config.php