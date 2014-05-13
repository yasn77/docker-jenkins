#!/bin/bash

# Read Env Vars set by Docker
source /docker.env

# Create a Jenkins default file, used by init script
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

# Set Jenkins user password, so we can SSH
JENKINS_PASSWD=$(openssl rand -base64 6)
echo JENKINS_PASSWORD=${JENKINS_PASSWD}
echo -e "${JENKINS_PASSWD}\n${JENKINS_PASSWD}" | passwd jenkins &>/dev/null

# Allow the Jenkins user to control Monit services
usermod -G monit -s /bin/bash jenkins

mkdir -p $(dirname ${PIDFILE}) $(dirname ${JENKINS_LOG}) ${JENKINS_HOME}/plugins
chown -R jenkins ${JENKINS_HOME} $(dirname ${PIDFILE}) $(dirname ${JENKINS_LOG})

# Enable downloaded plugins
for plugin in $(find /downloaded_plugins/ -type f -name "*.[hj]pi")
do
    ln -s ${plugin} ${JENKINS_HOME}/plugins/
done

# Set JNLP slave port if the environment variable is set
if [ -n "${JENKINS_SLAVE_JNLP}" ]
then
  sed -e "s/<slaveAgentPort>.*/<slaveAgentPort>${JENKINS_SLAVE_JNLP}<\/slaveAgentPort>/" -i ${JENKINS_HOME}/config.xml
fi

/etc/init.d/jenkins $1
