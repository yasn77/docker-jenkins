#!/bin/bash

env | egrep "^JENKINS|^TZ" > /docker.env

# Generate SSH host keys
rm -f "/etc/ssh/ssh_host_key"
rm -f "/etc/ssh/ssh_host_rsa_key"
rm -f "/etc/ssh/ssh_host_dsa_key"
rm -f "/etc/ssh/ssh_host_ecdsa_key"
rm -f "/etc/ssh/ssh_host_ed25519_key"
ssh-keygen -N '' -q -f "/etc/ssh/ssh_host_key" -t rsa1
ssh-keygen -N '' -q -f "/etc/ssh/ssh_host_rsa_key" -t rsa
ssh-keygen -N '' -q -f "/etc/ssh/ssh_host_dsa_key" -t dsa
ssh-keygen -N '' -q -f "/etc/ssh/ssh_host_ecdsa_key" -t ecdsa
ssh-keygen -N '' -q -f "/etc/ssh/ssh_host_ed25519_key" -t ed25519

MONIT_PASSWD=$(openssl rand -base64 6)
echo MONIT_PASSWORD=${MONIT_PASSWD}

groupadd monit
sed -e "s/__MONIT_PASSWD__/$MONIT_PASSWD/" -i /etc/monit/conf.d/enable_monit_webserver

sed -e 's/\(session.*pam_loginuid.so\)/\# \1/' -i /etc/pam.d/sshd

/usr/bin/monit -I -g monit -v
