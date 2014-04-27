FROM ubuntu:14.04
MAINTAINER Yasser Nabi "yassersaleemi@gmail.com"
VOLUME ["/var/lib/jenkins"]
ENV JENKINS_HOME /var/lib/jenkins
ENV JENKINS_VER 1.557
ENV JENKINS_JAVA_ARGS '-Djava.awt.headless=true'
ENV JENKINS_MAXOPENFILES 8192
ENV JENKINS_PREFIX /jenkins
ENV JENKINS_ARGS '--webroot=/var/cache/jenkins/war --httpPort=8080 --ajp13Port=-1'
ENV TZ Europe/London
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 8080 2812


# Pin openssl to avoid heartbleed
RUN echo "Package: openssl\nPin: version 1.0.1-4ubuntu5.12\nPin-Priority: 500\n\nPackage: libssl1.0.0\nPin: version 1.0.1-4ubuntu5.12\nPin-Priority: 500" > /etc/apt/preferences.d/openssl

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
        apt-get update && \
        apt-get -y install \
            openssh-server \
            monit \
            curl \
            openjdk-7-jre-headless \
            git \
            subversion

ADD ./monit.d/ /etc/monit/conf.d/
ADD ./jenkins.sudoers /etc/sudoers.d/jenkins
ADD ./jenkins_init_wrapper.sh ./jenkins_init_wrapper.sh
ADD ./start.sh /start.sh

RUN curl -s -L -o /tmp/jenkins_${JENKINS_VER}_all.deb http://pkg.jenkins-ci.org/debian/binary/jenkins_${JENKINS_VER}_all.deb && \
        dpkg -i /tmp/jenkins_${JENKINS_VER}_all.deb ; \
        apt-get -fy install

ENTRYPOINT ["/bin/bash", "/start.sh"]
