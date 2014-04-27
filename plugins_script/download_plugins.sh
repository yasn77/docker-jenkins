#!/bin/bash

mkdir -p /downloaded_plugins

cd /downloaded_plugins
for p in $(cat /plugins_script/plugins.txt)
do
    echo "Adding Jenkins Plugin ${p}..."
    if ! curl -f -L -s -O http://updates.jenkins-ci.org/latest/${p}.hpi
    then
        curl -f -L -s -O http://updates.jenkins-ci.org/latest/${p}.jpi
    fi
done
