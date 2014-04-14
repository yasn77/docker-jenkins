docker-jenkins
==============

````
OS Base : Ubuntu 12.04

Jenkins version :  1.557

Exposed Port : 8080

Jenkins Home : /var/lib/jenkins

Timezone : Europe/London
````

Set the image timezone
```docker run --env TZ=<TIMEZONE> -d -P <CONTAINER>```

You can also add plugins in to the image by downloading in to the plugins directory
