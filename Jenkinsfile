/* groovylint-disable , NestedBlockDepth, VariableTypeRequired */
/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent {
        label 'slave-zero'
    }
    options {
        /* groovylint-disable-next-line LineLength */
        buildDiscarder logRotator(artifactDaysToKeepStr: '',
         artifactNumToKeepStr: '',
         daysToKeepStr: '1',
          numToKeepStr: '3')
    }
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
            when {
                branch 'staging-*'
            }
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
            when {
                branch 'staging-*'
            }
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

        stage('provision infrastructure') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                       string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        dir('Terraform') {
                            sh 'ls -l'
                            sh "echo ${AWS_ACCESS_KEY_ID}"
                            // sh 'chmod +x TFswitch.sh'
                            // sh 'chmod +x main.tf'
                            sh './TFswitch.sh init'
                            sh ' ./TFswitch.sh plan'
                        }
                }
            }
        }
    }
}
