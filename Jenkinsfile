/* groovylint-disable , NestedBlockDepth, VariableTypeRequired */
/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent {
        label 'slave-zero'
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
            // agent {
            //     docker {
            //         image 'hashicorp/terraform:light'
            //         // label 'slave-zero'
            //         // args  '--entrypoint=""'
            //         args 'docker run --rm -it -v $PWD:/data -w /data hashicorp/terraform:light init'
            //     }
            // }
            steps {
                dir('Terraform') {
                   sh 'ls -l'

                }
            }

            // steps {
            //     sh 'terraform version'
            //     // sh 'terraform  -v $PWD/Terraform:/data -w /data init'
            //     sh 'terraform  plan'
            // }
        }
    }
}

