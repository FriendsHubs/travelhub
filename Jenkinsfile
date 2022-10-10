pipeline {
    agent {
        docker { image 'node:16.13.1-alpine' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'sudo node --version'
            }
        }
    }
}





// pipeline {
//     agent any

//     stages {
//         stage('build frontend') {
//             // agent {
//             //     docker {
//             //         image 'alpine:3.15'
//             //         reuseNode: true
//             //     }
//             // }
//             steps {
//                 sh "cd frontend"
//                 sh "yarn build"
//             }
//         }
//         stage('test frontend') {
//             steps {
//                 echo 'Building.. two again'
//             }
//         }
//         stage('Deploy') {
//             steps {
//                 echo 'Deploying....'
//             }
//         }
//     }
// }