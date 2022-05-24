#!/bin/bash
sudo pacman --noconfirm -Sy $(pacman -Ssq php-)

# sudo sed -i 's/;sp.configuration_file/sp.configuration_file/g' /etc/php/conf.d/snuffleupagus.ini

sudo pacman --noconfirm -Sy apache php-apache phpmyadmin mariadb certbot certbot-apache

sudo cp /home/arch/init-scripts/files/httpd.conf /etc/httpd/conf/httpd.conf
sudo cp /home/arch/init-scripts/files/phpmyadmin.conf /etc/httpd/conf/extra/phpmyadmin.conf
sudo chown -R root:root /etc/httpd/conf/httpd.conf
sudo cp /home/arch/init-scripts/files/index.php /srv/http/index.php

sudo touch /etc/httpd/conf/extra/php-fpm.conf
echo "DirectoryIndex index.php index.html" | sudo tee -a /etc/httpd/conf/extra/php-fpm.conf
echo "<FilesMatch \.php$>" | sudo tee -a /etc/httpd/conf/extra/php-fpm.conf
echo 'SetHandler "proxy:unix:/run/php-fpm/php-fpm.sock|fcgi://localhost/"' | sudo tee -a /etc/httpd/conf/extra/php-fpm.conf
echo '</FilesMatch>' | sudo tee -a /etc/httpd/conf/extra/php-fpm.conf
sudo sed -i 's/;extension=mysqli/extension=mysqli/g' /etc/php/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/g' /etc/php/php.ini

sudo chown -R arch:arch /srv/http

sudo systemctl start php-fpm --now
sudo systemctl enable php-fpm --now
sudo systemctl start httpd --now
sudo systemctl enable httpd --now

sudo rm /etc/my.cnf.d/server.cnf
sudo cp /home/arch/init-scripts/files/server.cnf /etc/my.cnf.d/server.cnf
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo mysqladmin -u root password "superpass"
sudo mariadb < /home/arch/init-scripts/files/mysql.host.sql
sudo mariadb < /usr/share/webapps/phpMyAdmin/sql/create_tables.sql
sudo cp /home/arch/init-scripts/files/phpmyadmin.config /usr/share/webapps/phpMyAdmin/config.inc.php

sudo systemctl start mariadb.service --now
sudo systemctl enable mariadb.service --now
sudo systemctl restart mariadb.service --now

sudo mariadb < /home/arch/init-scripts/files/phpmyadmin.sql