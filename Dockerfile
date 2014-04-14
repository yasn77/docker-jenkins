FROM ubuntu:12.04
MAINTAINER Yasser Nabi "yassersaleemi@gmail.com"
VOLUME ["/var/lib/jenkins"]
ENV JENKINS_HOME /var/lib/jenkins
ENV JENKINS_VER 1.557
ENV TZ Europe/London
EXPOSE 8080


# Pin openssl to avoid heartbleed
RUN echo "Package: openssl\nPin: version 1.0.1-4ubuntu5.12\nPin-Priority: 500\n\nPackage: libssl1.0.0\nPin: version 1.0.1-4ubuntu5.12\nPin-Priority: 500" > /etc/apt/preferences.d/openssl
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openjdk-7-jre-headless curl

ADD ./plugins/ ${JENKINS_HOME}/plugins/

ADD http://pkg.jenkins-ci.org/debian/binary/jenkins_${JENKINS_VER}_all.deb /tmp/jenkins_${JENKINS_VER}_all.deb
ADD ./start-jenkins.sh /start-jenkins.sh

RUN dpkg -i /tmp/jenkins_${JENKINS_VER}_all.deb ; DEBIAN_FRONTEND=noninteractive apt-get -fy install
RUN chmod +x /start-jenkins.sh 
RUN chown -R jenkins ${JENKINS_HOME}

ENTRYPOINT ["/start-jenkins.sh"]
