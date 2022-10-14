// pipeline {
//     agent {
//         docker { image 'node:16.13.1-alpine' }
//     }
//     stages {
//         stage('Test') {
//             steps {
//                 sh 'node --version'
//             }
//         }
//     }
// }





pipeline {
    agent { label 'jenkins-agent' }

    stages {
        stage('build frontend') {
    // agent {
    //     docker { image 'node:16.13.1-alpine' }
    // }
            steps {
               dir('frontend'){

                sh "ls"
                sh "npm install"
                sh "npm run build"
               }
            }
        }
        // stage('test frontend') {
        //     steps {
        //         echo 'Building.. two again'
        //     }
        // }
        // stage('Deploy') {
        //     steps {
        //         echo 'Deploying....'
        //     }
        // }
    }
}