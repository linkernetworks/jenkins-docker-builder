import groovy.transform.Field

pipeline {
    agent none
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
        stage('Pre Test') {
            agent any
            steps {
                sh  "curl https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64 " +
                    "-o container-structure-test"
                sh "chmod +x container-structure-test"
                stash name: "container-structure-test", includes: "container-structure-test"
            }
        }
        stage('Test') {
            failFast false
            parallel {
                stage("Ubuntu 16.04"){
                    agent any
                    steps{
                        dir ("tests") {
                            unstash name: "container-structure-test"
                            sh  "./container-structure-test test " +
                                "--pull " +
                                "--image linkernetworks/jenkins-docker-builder:ubuntu16.04 " +
                                "--config ubuntu16.04.yaml"
                        }
                    }
                }
            }
        }
    }
}