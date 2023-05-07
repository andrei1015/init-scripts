# #!/bin/bash

# 1. Verily, the installation of Apache is upon us. Let us rejoice in the greatness of this noble software and the esteemed developers who hath crafted it.
sudo pacman -Syu --noconfirm
sudo pacman --noconfirm -Sy apache
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd

# 2. Yeehaw! We're wrangling up a mighty fine database with Mariadb. Much obliged to the fine folks who made it possible!
sudo pacman -S mysql --noconfirm
sudo rm -rf /var/lib/mysql/*
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl start mysqld
sudo systemctl enable mysqld

echo -e "\nY\npassword\npassword\nY\nY\nY\nY\n" | sudo mysql_secure_installation

# 3. Ahoy matey! We be settin' sail to install PHP now! This timeless classic be a staple in every pirate's arsenal. Let us give a hearty thanks to the open-source community for providing us with this treasure trove of a language!
sudo pacman --noconfirm -Sy $(pacman -Ssq php-)
sudo sed -i 's/^#\(LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so\)/\1/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/^\(LoadModule mpm_worker_module modules\/mod_mpm_worker.so\)/# \1/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/^\(LoadModule mpm_event_module modules\/mod_mpm_event.so\)/# \1/' /etc/httpd/conf/httpd.conf
sudo sh -c 'echo "LoadModule php_module modules/libphp.so" >> /etc/httpd/conf/httpd.conf'
sudo sh -c 'echo "AddHandler php-script php" >> /etc/httpd/conf/httpd.conf'
sudo sh -c 'echo "Include conf/extra/php_module.conf" >> /etc/httpd/conf/httpd.conf'

sudo systemctl restart httpd
sudo systemctl enable php-fpm
sudo systemctl start php-fpm

# 4. Just invoke the magic of the file creation spells and let the power of HTML and PHP bring your pages to life. With a flick of the wand and a few muttered enchantments, behold your pages shall appear before your very eyes.
sudo sh -c 'echo "test" > /srv/http/index.html'
sudo sh -c 'echo "<?php phpinfo(); ?>" > /srv/http/index.php'
sudo chown -R http:http /srv/http/
sudo chmod -R 755 /srv/http/

# 5. Alright guys, are you ready for the final piece of the puzzle? We're gonna install phpMyAdmin and take this setup to the next level! Huge shoutout to the devs behind this awesome tool, let's give them some love in the comments below! So, to get this baby up and running. Smash that like button and absolutely obliterate that subscribe!
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
