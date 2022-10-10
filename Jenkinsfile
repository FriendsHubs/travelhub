pipeline {
    agent any

    stages {
        stage('build frontend') {
            agent {
                docker {
                    image 'alpine:3.15'
                    reuseNode: true
                }
            }
            steps {
                sh cd frontend
                yarn build

            }
        }
        stage('test frontend') {
            steps {
                echo 'Building.. two again'
            }
        }
        stage('') {
            steps {
                sh cd frontend
                
            }
            steps {
                yarn build
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}