docker-jenkins
==============
    OS Base : jenkinsci/jenkins
    Jenkins version : 1.624
    Exposed Ports : 8080 2812 22 50000
    Jenkins Home : /var/jenkins_home
    Timezone : Europe/London

Environment Variables
---------------------
    TZ
        Container Timezone. Default 'Europe/London'

Services
--------
    Jenkins LTS
    Monit
    SSHD

This container uses the [official Jenkins image](https://github.com/jenkinsci/docker) as its base. I would suggest reading the documentation for the official image first, as all the environment variable options are supported.

You change the Timezone by runnning:

    docker run --env TZ=<TIMEZONE> -d <CONTAINER_ID>

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

    ./plugins.txt
