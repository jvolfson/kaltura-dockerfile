#!/bin/bash


if [ -e /root/install/config.ans ]; then
  . /root/install/config.ans
fi


# set SElinux enforcement to permissive
setenforce permissive

echo "
127.0.0.1 dockerhost
" >> /etc/hosts


# start dependency services
service httpd start
service mysqld start

#curl dockerhost:$KALTURA_CONTAINER_PORT
#cat /etc/hosts

# make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('$SUPER_USER_PASSWD') WHERE User = 'root'"

# delete anonymous users
mysql -e "DELETE FROM mysql.user WHERE User = ''"
mysql -e "DELETE FROM mysql.user WHERE Host LIKE 'localhost'"
mysql -e "DELETE FROM mysql.user WHERE Host LIKE '`hostname`'"

# delete demo database
mysql -e "DROP DATABASE test"

# make our changes take effect
mysql -e "FLUSH PRIVILEGES"


# set predefined admin secrets and passwords for template partner
sed -e 's@# SQL statement files tokens:@. /root/install/secrets.sh@g' -i '/opt/kaltura/bin/kaltura-base-config.sh'


# installing kaltura
/opt/kaltura/bin/kaltura-mysql-settings.sh

if [ -e /root/install/config.ans ]; then
	/opt/kaltura/bin/kaltura-config-all.sh /root/install/config.ans
else
	/opt/kaltura/bin/kaltura-config-all.sh
fi
