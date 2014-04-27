#!/bin/bash

env | egrep "^JENKINS|^TZ" > /docker.env

MONIT_PASSWD=$(openssl rand -base64 6)
echo MONIT_PASSWORD=${MONIT_PASSWD}

groupadd monit
sed -e "s/__MONIT_PASSWD__/$MONIT_PASSWD/" -i /etc/monit/conf.d/enable_monit_webserver

sed -e 's/\(session.*pam_loginuid.so\)/\# \1/' -i /etc/pam.d/sshd

/usr/bin/monit -I -g monit -v
