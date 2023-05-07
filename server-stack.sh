# #!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman --noconfirm -Sy apache
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl status httpd.service

sudo pacman -S mysql --noconfirm

sudo rm -rf /var/lib/mysql/*
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service

echo -e "\nY\npassword\npassword\nY\nY\nY\nY\n" | sudo mysql_secure_installation

sudo pacman -Sy php php-apache php-gd php-mcrypt --noconfirm
sudo sed -i 's/^#\(LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so\)/\1/' /etc/httpd/conf/httpd.conf
sudo sh -c 'echo "LoadModule php_module modules/libphp.so" >> /etc/httpd/conf/httpd.conf'
sudo sh -c 'echo "AddHandler php-script php" >> /etc/httpd/conf/httpd.conf'
sudo sh -c 'echo "Include conf/extra/php_module.conf" >> /etc/httpd/conf/httpd.conf'

sudo systemctl restart httpd

echo "test" > /srv/http/index.html

echo "<?php\nphpinfo()\n?>" | tee /srv/http/test.php > /dev/null

sudo pacman -S --noconfirm phpmyadmin

sudo sed -i 's/^;\(extension=mysqli\)/\1/' /etc/php/php.ini
sudo sed -i 's/^;\(extension=pdo_mysql\)/\1/' /etc/php/php.ini
sudo sed -i 's/^;\(extension=iconv\)/\1/' /etc/php/php.ini

cat <<EOF > /etc/httpd/conf/extra/phpmyadmin.conf
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
	DirectoryIndex index.php
	AllowOverride All
	Options FollowSymlinks
	Require all granted
</Directory>
EOF

echo 'Include conf/extra/phpmyadmin.conf' | sudo tee -a /etc/httpd/conf/httpd.conf

sudo systemctl restart httpd
