#! /bin/bash

echo "add mysqld config"
sed -i -e '34a table_open_cache=128' /etc/mysql/my.cnf
sed -i -e '34a table_definition_cache=200' /etc/mysql/my.cnf
sed -i -e '34a performance_schema_max_table_instances=200' /etc/mysql/my.cnf

sudo service mysql restart
if [ $? -eq 0 ]; then
	echo "mysql startup successful!"
else
	echo "mysql startup failed!"
	exit 1
fi

echo "create ss-panel database, user, password"
mysql -uroot -p'pw123456' -e "CREATE DATABASE sspanel character SET utf8; CREATE user 'ssuser'@'localhost' IDENTIFIED BY 'sspasswd'; GRANT ALL privileges ON sspanel.* TO 'ssuser'@'localhost'; FLUSH PRIVILEGES;"

echo "input shadowsocks sql init database"
cd /opt/shadowsocks/shadowsocks; mysql -u ssuser -psspasswd sspanel < ./shadowsocks.sql

echo "input ss-panel sql into database"
cd /opt/ss-panel; mysql -u ssuser -psspasswd sspanel < db-160212.sql
