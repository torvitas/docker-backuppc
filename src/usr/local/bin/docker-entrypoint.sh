#!/bin/bash

if [ -n "/var/lib/BackupPC" ]; then
    mkdir -p /var/lib/BackupPC

fi
if [ ! -f "/var/lib/BackupPC/passwd/htpasswd" ]; then
    apk add apache2-utils pwgen --update --no-cache
    mkdir -p /var/lib/BackupPC/passwd
    password=$(pwgen -n 8 1)
    htpasswd -bc /var/lib/BackupPC/passwd/htpasswd backuppc ${password}
    apk del apache2-utils pwgen
	echo \
"=========================================================

Use these credentials to log in to https://${VIRTUAL_HOST}:

backuppc:${password}

=========================================================
"
fi
chown backuppc:backuppc -R /var/lib/BackupPC

if [ ! -f "/etc/BackupPC/config.pl" ]; then
    mkdir -p /etc/BackupPC
    cp -r /usr/share/BackupPC/etc/* /etc/BackupPC/
	sed -e "s/\$Conf{CgiAdminUsers}     = '';/\$Conf{CgiAdminUsers}     = 'backuppc';/g" \
    	-i /etc/BackupPC/config.pl
fi
chown backuppc:backuppc -R /etc/BackupPC

if [ ! -f "/var/lib/BackupPC/passwd/htpasswd" ]; then
    htpasswd backuppc $(pwgen -n 40 1) -c /var/lib/BackupPC/passwd/htpasswd
fi

chmod +s /bin/ping

su backuppc -c '
    if [ ! -f ~/.ssh/id_rsa ]; then
      ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
    fi
	echo \
"=========================================================

Use this SSH key:

$(cat ~/.ssh/id_rsa.pub)

=========================================================
"
'

supervisord -c /usr/local/etc/supervisor.conf
