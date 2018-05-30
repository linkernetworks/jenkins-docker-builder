#!/bin/bash

UID=`id -u`
GID=`id -g`

#addgroup --gid $GID jenkins
#adduser -q --uid $UID --gid $GID --disabled-password --gecos "" jenkins

echo 'jenkins:x:'$GID':' >> /etc/group
echo 'jenkins:x:'$UID':'$GID':,,,:/home/jenkins:/bin/bash' >> /etc/passwd


bash
