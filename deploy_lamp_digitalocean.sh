#!/bin/bash
clear
echo +++++++++++++++++++++++++++++++++++++++++++++
echo + Choose Option +
echo +++++++++++++++++++++++++++++++++++++++++++++
echo "1- Insall LAMP Stack ( PHP 8.0 ) +  NPM"
echo "2- Install SSL"
echo "3- Add Laravel to apache config"
echo "4- Create laravel Privileges"
echo "5- Create ssh keys for github"
echo "6- Exit"

############################# read php version choice ##############################
read character
case $character in
1) echo "Selected Insall LAMP Stack ( PHP 8.0 ) " ;;
2) echo "Selected Install SSL" ;;
3) echo "Add Laravel to apache config" ;;
4) echo "Create laravel Privileges" ;;
4) echo "Create ssh keys for github" ;;
6) echo "exit" ;;

esac

if [ ! -z "$character" ]; then
   ################################### if operating system is linux #############################
   export server_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
   ################################# if OS is Ubuntu ############################################
   if [ $server_name = '"Ubuntu"' ]; then
      
      if [[ $character == 1 ]]; then
      ################################# Install LAMP ############################################
      echo "Please Set MYSQL Password"
      read db_pass
      echo +++++++++++++++++++++++++++++++++++++++++++++
      echo +++++++++++++++++++++++++++++++++++++++++++++
      echo +++++++++++++ Installing LAMP +++++++++++++++
      echo +++++++++++++++++++++++++++++++++++++++++++++
      echo +++++++++++++++++++++++++++++++++++++++++++++
         ################## install apache ##############
         sudo apt-get update -y
         sudo apt-get install apache2 -y
         sudo a2enmod rewrite
         sudo service apache2 restart
         ################## install mysql server ##############
         sudo apt-get install mysql-server -y
         ################## install php ##############
         sudo apt-get install python-software-properties
         echo -ne '\n' | sudo add-apt-repository ppa:ondrej/php
         sudo apt-get update
         sudo apt-get install php8.0 -y
         sudo apt-get install php-pear php8.0-curl php8.0-dev php8.0-gd php8.0-mbstring php8.0-zip php8.0-mysql php8.0-xml php8.0-bcmath -y
         ################## install composer ##############
         sudo apt install composer -y
         ################## install nodejs ##############
         sudo apt install nodejs -y
         ################## install npm ##############
         sudo apt install npm -y
         ################## set mysql db password ##############
         mysql -u root -D mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$db_pass';"
         mysql -u root -p$db_pass -e "flush privileges;"

      elif [[ $character == 2 ]]; then
         ################################# Install SSL ############################################
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++ Installing SSL +++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++

         sudo apt install certbot python3-certbot-apache
         sudo apache2ctl configtest
         sudo systemctl reload apache2
         sudo ufw allow 'Apache Full'
         sudo ufw delete allow 'Apache'
         sudo certbot --apache

      elif [[ $character == 3 ]]; then
         ################################# Add Laravel to apache config ############################################
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo ++++++ Add Laravel to apache config +++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo "Please Insert Project Full Path"
         read laravel_proj_path
         echo "Please Insert domain name"
         read domain_name
         if [[ (! -z "$laravel_proj_path") && (! -z "$domain_name")]]; then
         mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/old.conf
            file="/etc/apache2/sites-available/000-default.conf"
                     echo "<VirtualHost *:80>
                        ServerName $domain_name
                        ServerAlias www.$domain_name
                        DocumentRoot $laravel_proj_path/public
                        <Directory $laravel_proj_path/public>
                              Options Indexes FollowSymLinks MultiViews
                              AllowOverride All
                              Require all granted
                        </Directory>
                        RewriteEngine on
                  </VirtualHost>
                     " >$file
         cat $file
         sudo service apache2 restart
         fi
         
      elif [[ $character == 4 ]]; then
       ################################# Create laravel Privileges ############################################
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++ Create laravel Privileges +++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo "Please Insert Project Full Path"
         read proj_path
         cd $proj_path
         chmod -R 775 bootstrap/
         chmod -R 775 public/
         chmod -R 775 storage/
         chmod -R 755 storage/
         sudo chgrp -R www-data storage bootstrap/cache
         sudo chmod -R ug+rwx storage bootstrap/cache
         sudo chgrp -R www-data public/
         sudo chmod -R ug+rwx storage public
      elif [[ $character == 5 ]]; then
       ################################# Create ssh keys for github ############################################
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo ++++++++ Create ssh keys github +++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo -ne '\n' | ssh-keygen -t rsa -b 2048 -C "github"
         echo +++++++++++++++++++++++++++++++++++++++++++++
         echo ++++++++ ssh key Is: +++++++++++++
         cat /root/.ssh/id_rsa.pub

      else
         echo "No Version Selected" exit
      fi
     

   else
   ################################# if OS is CentOS ############################################
      if [ $server_name = '"CentOS Linux"' ]; then
   echo "CentOS is not supported yet"
   else
   echo "Your system is not supported"
   fi

   fi

   ################################### if operating system is macOS #############################
   elif [[ "$OSTYPE" == "darwin"* ]]; then
   echo "MAC OS is not supported yet"
   else
   echo "Your system is not supported"
   fi
