docker-jenkins
==============
    OS Base : Ubuntu 14.04
    Jenkins version :  1.557
    Exposed Ports : 8080 2812 22
    Jenkins Home : /var/lib/jenkins
    Timezone : Europe/London

Environment Variables
---------------------
    JENKINS_JAVA_ARGS
        Arguments to pass to Java when Jenkins starts. Default : '-Djava.awt.headless=true'
    JENKINS_MAXOPENFILES
        Ulimit maxopenfiles for Jenkins. Default '8192'
    JENKINS_PREFIX
        URL prefix. Default '/jenkins'
    JENKINS_ARGS
        Start up arguements for Jenkins. Default '--webroot=/var/cache/jenkins/war --httpPort=8080 --ajp13Port=-1'
    TZ
        Container Timezone. Default 'Europe/London'

Services
--------
    Jenkins
    Monit
    SSHD


When running the image, you can pass in environment variables that will affect the behaviour of Jenkins.
An example, you change the Timezone by runnning:
    
    docker run --env TZ=<TIMEZONE> -d <CONTAINER_ID>
Or change Java heap size:
    
    docker run --env JENKINS_JAVA_ARGS=-Xmx4g -d <CONTAINER_ID>

Monit is used to control the start up and management of Jenkins (and SSHD). You can access the monit webserver
by exposing port 2812 on the Docker host. The user name is `monit` and password can be found by running:
    
    docker logs <CONTAINER_ID> 2>/dev/null | grep MONIT_PASSWORD

OpenSSH is also running, you can ssh to the container by exposing port 22 on your Docker host and using the username
`jenkins`. Password can be found by running:
    
    docker logs <CONTAINER_ID> 2>/dev/null | grep JENKINS_PASSWORD

Plugins
-------

The following list of plugins come included in the container:

    config-file-provider
    envinject
    git
    git-client
    git-server
    github
    github-api
    greenballs
    multiple-scms
    parameterized-trigger
    promoted-builds
    scm-api
    scm-sync-configuration
    scriptler
    swarm
    token-macro
    xunit
It is possible to customise the plugins that get added to the image by updating:

    ./plugins_script/plugins.txt
