node {
    docker.image('node:16-buster-slim').inside('--network host -p 3000:3000 --user root') {
        stage('Checkout') {
            checkout scm
            sh 'echo "=== Checkout Stage ===" > log.txt'
        }

        stage('Build') {
            try {
                sh 'echo "=== Build Stage ===" >> log.txt'
                sh 'npm install >> log.txt 2>&1'
                sh 'npm run build >> build_log.txt 2>&1'
            } finally {
                archiveArtifacts artifacts: 'log.txt, build_log.txt', allowEmptyArchive: true
            }
        }

        stage('Test') {
            try {
                sh 'echo "=== Test Stage ===" >> log.txt'
                sh './jenkins/scripts/test.sh >> log.txt 2>&1'
            } finally {
                archiveArtifacts artifacts: 'log.txt', allowEmptyArchive: true
            }
        }

        stage('Manual Approval') {
            input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed', cancel: 'Abort'
        }

        stage('Deploy') {
            try {
                sh 'echo "=== Deploy Stage ===" >> log.txt'
                sh './jenkins/scripts/deliver.sh >> log.txt 2>&1'
                echo "Pipeline akan dijeda selama 1 menit..."
                sleep time: 1, unit: 'MINUTES'
                sh './jenkins/scripts/kill.sh >> log.txt 2>&1'
            } finally {
                archiveArtifacts artifacts: 'log.txt', allowEmptyArchive: true
            }
        }

//         stage('Deploy') {
//             try {
//                 sh 'echo "=== Deploy to Server Stage ===" >> log.txt'
//                 sh 'apt-get update && apt-get install -y openssh-client >> log.txt 2>&1'
//
//                 withCredentials([sshUserPrivateKey(credentialsId: '8b0b5e66-4b7d-4887-953c-6b114a06cb90', keyFileVariable: 'AWS_SSH_KEY', usernameVariable: 'SSH_USER')]) {
//                     sh 'mkdir -p ~/.ssh && ssh-keyscan -H 54.169.12.75 >> ~/.ssh/known_hosts'
//
//                     sh 'scp -i $AWS_SSH_KEY -r ./build/ $SSH_USER@54.169.12.75:/home/ubuntu/my-react-app/ >> log.txt 2>&1'
//
//                     sh 'ssh -i $AWS_SSH_KEY $SSH_USER@54.169.12.75 << EOF\n' +
//                        'sudo cp -r /home/ubuntu/my-react-app/build/* /var/www/my-react-app/\n' +
//                        'EOF >> log.txt 2>&1'
//
//                     echo "Aplikasi berhasil dideploy di server AWS."
//                 }
//             } catch (Exception e) {
//                 currentBuild.result = 'FAILURE'
//                 throw e
//             } finally {
//                 archiveArtifacts artifacts: 'log.txt', allowEmptyArchive: true
//             }
//         }
    }
}