FROM jenkins:1.609.2
MAINTAINER Yasser Nabi "yassersaleemi@gmail.com"
ENV JAVA_OPTS '-Djava.awt.headless=true'
ENV TZ Europe/London
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 8080 50000

USER root
RUN apt-get update && apt-get -y install \
            sudo \
            openssh-server \
            monit \
            git \
            subversion

ADD ./monit.d/ /etc/monit/conf.d/
ADD ./jenkins.sudoers /etc/sudoers.d/jenkins
ADD ./jenkins_init_wrapper.sh /jenkins_init_wrapper.sh
ADD ./start.sh /start.sh

COPY plugins.txt /usr/share/jenkins/
USER jenkins
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
USER root

ENTRYPOINT ["/bin/bash", "/start.sh"]
