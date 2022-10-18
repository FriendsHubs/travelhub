/* groovylint-disable , NestedBlockDepth, VariableTypeRequired */
/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent {
        label 'slave-zero'
    }
    // agent {  }
    // agent {
    //     docker {
    //         image 'node:16.13.1-alpine'
    //         label 'slave-zero'
    //     }
    // }
    // environment {
    //     tools {
    //         'org.jenkinsci.plugins.docker.commons.tools.DockerTool' 'docker'
    //     }
    // }
    parameters {
        string(
            name: 'Branch_Name',
            defaultValue: 'dev',
            description: '')
        string(
            name: 'Image_Name',
            defaultValue: 'travel_hub',
            description: '')
        string(
            name: 'Image_Tag',
            defaultValue: 'latest',
            description: 'Image tag')
    }
    stages {
        stage('build frontend docker image') {
            steps {
                dir('frontend') {
                    sh 'whoami'
                    sh 'ls'
                    sh 'which docker'
                    script {
                        docker.build(
                   "${params.Image_Name}:${params.Image_Tag}")
                    }
                }
            }
        }
        stage('Push to Dockerhub') {
            steps {
                script {
                    echo 'Pushing the image to docker hub'
                    def localImage = "${params.Image_Name}:${params.Image_Tag}"

                /* groovylint-disable-next-line VariableTypeRequired */
                    def repositoryName = "emmanuelekama/${localImage}"

                    // Create a tag that going to push into DockerHub
                    sh "docker tag ${localImage} ${repositoryName} "
                    docker.withRegistry('', 'DockerHubCredentials') {
                        def image = docker.image("${repositoryName}")
                        image.push()
                    }
                }
            }
        }
    }
}
