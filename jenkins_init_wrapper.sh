#!/bin/bash

source /docker.env

cat <<EOF > /etc/default/jenkins
NAME=jenkins
JAVA=/usr/bin/java
JAVA_ARGS="${JENKINS_JAVA_ARGS}"
PIDFILE=/var/run/jenkins/jenkins.pid
JENKINS_USER=jenkins
JENKINS_WAR=/usr/share/jenkins/jenkins.war
JENKINS_HOME="${JENKINS_HOME}"
RUN_STANDALONE=true
JENKINS_LOG=/var/log/jenkins/\$NAME.log
MAXOPENFILES=${JENKINS_MAXOPENFILES}
HTTP_PORT=8080
AJP_PORT=-1
PREFIX="${JENKINS_PREFIX}"
JENKINS_ARGS="${JENKINS_ARGS}"

EOF

source /etc/default/jenkins

JENKINS_PASSWD=$(openssl rand -base64 6)
echo JENKINS_PASSWORD=${JENKINS_PASSWD}
echo -e "${JENKINS_PASSWD}\n${JENKINS_PASSWD}" | passwd jenkins &>/dev/null
usermod -G monit -s /bin/bash jenkins

mkdir -p $(dirname ${PIDFILE}) $(dirname ${JENKINS_LOG})
chown -R jenkins ${JENKINS_HOME} $(dirname ${PIDFILE}) $(dirname ${JENKINS_LOG})

/etc/init.d/jenkins $1
