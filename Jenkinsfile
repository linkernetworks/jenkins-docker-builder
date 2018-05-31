import groovy.transform.Field

pipeline {
    agent none
    parameters {
        booleanParam(
            name: 'DEPLOY',
            defaultValue: false,
            description: 'If true, deploy images to Docker Hub.'
        )
    }
    options {
        timestamps()
        disableConcurrentBuilds()
    }
    stages {
        stage('Build') {
            failFast false
            parallel {
                stage("Ubuntu 16.04"){
                    agent any
                    steps{
                        dir ("ubuntu16.04") {
                            script {
                                def image = docker.build(
                                    "linkernetworks/jenkins-docker-builder:ubuntu16.04",
                                    "--pull ."
                                )
                                if (params.DEPLOY) {
                                    withCredentials([
                                        usernamePassword(
                                            credentialsId: 'docker_hub_linkernetworks',
                                            usernameVariable: 'DOCKER_USER',
                                            passwordVariable: 'DOCKER_PASS'
                                        )
                                    ]) {
                                        sh('echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin')
                                    }
                                    image.push()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}