#!/bin/bash
chown -R jenkins ${JENKINS_HOME}
exec su jenkins -c "java ${JAVA_ARGS} -DJENKINS_HOME=${JENKINS_HOME} -jar /usr/share/jenkins/jenkins.war ${JENKINS_OPTS}"
