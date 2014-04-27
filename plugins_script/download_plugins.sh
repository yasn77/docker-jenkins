#!/bin/bash
if [ ! -d ${JENKINS_HOME}/plugins ]
then
    mkdir -p ${JENKINS_HOME}/plugins
fi
cd ${JENKINS_HOME}/plugins
for p in $(cat ${JENKINS_HOME}/plugins.txt)
do
    echo "Adding Jenkins Plugin ${p}..."
    curl -L -s -O ${p}
done
cd ${OLDPWD}
