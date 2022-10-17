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

/* groovylint-disable-next-line CompileStatic */
pipeline {
    // agent {  }
    agent {
        label 'slave-zero'
        // docker {
        //     image 'node:16.13.1-alpine'
        //     label 'slave-zero'
        // // args  '-v /tmp:/tmp'
        // }
    }

    stages {
        stage('build frontend') {
            steps {
                dir('frontend') {
                    sh "whoami"
                    sh 'ls'
                    sh 'npm install'
                    sh 'npm run build'
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
