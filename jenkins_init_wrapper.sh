#!/bin/bash

# Set the umask due to a bug in Monit #https://bitbucket.org/tildeslash/monit/issues/104
umask 0022

# Set Jenkins user password, so we can SSH
JENKINS_PASSWD=$(openssl rand -base64 6)
echo JENKINS_PASSWORD=${JENKINS_PASSWD}
echo -e "${JENKINS_PASSWD}\n${JENKINS_PASSWD}" | passwd jenkins &>/dev/null

# Allow the Jenkins user to control Monit services
usermod -G monit -s /bin/bash jenkins

su --preserve-environment jenkins '/usr/local/bin/jenkins.sh'
pgrep -f /usr/share/jenkins/jenkins.war > /var/run/jenkins.pid
