# jenkins-docker-builder
A docker in docker image which is customized for Jenkins agent

## Ubuntu 16.04

```groovy
pipeline {
    ...
    agent {
        docker {
            image "linkernetworks/jenkins-docker-builder:ubuntu16.04"
            args "--privileged --group-add docker" // required
            alwaysPull true
        }
    }
    ...
    stages {
        stage ("Run docker in docker") {
            steps {
                sh "whoami" // jenkins
                sh "service docker status"
                sh "docker run hello-world"
            }
        }
    }
}
```
