node {
    docker.image('node:16-buster-slim').inside('--network host -p 3000:3000 --user root') {
        stage('Build') {
            try {
                sh 'npm install > log.txt 2>&1'
            } finally {
                archiveArtifacts artifacts: 'log.txt', allowEmptyArchive: true
            }
        }
        stage('Test') {
            try {
                sh './jenkins/scripts/test.sh > log.txt 2>&1'
            } finally {
                archiveArtifacts artifacts: 'log.txt', allowEmptyArchive: true
            }
        }
//         stage('Manual Approval') {
//             input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed', parameters: [
//                 choice(name: 'Action', choices: ['Proceed', 'Abort'], description: 'Pilih apakah ingin melanjutkan ke tahap Deploy atau menghentikan eksekusi pipeline')
//             ]
//         }
        stage('Deploy') {
            try {
                // Install SSH dan SCP di dalam container
                sh 'apt-get update && apt-get install -y openssh-client'

                withCredentials([sshUserPrivateKey(credentialsId: '8b0b5e66-4b7d-4887-953c-6b114a06cb90', keyFileVariable: 'AWS_SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    // Tambahkan kunci host AWS ke known_hosts untuk menghindari "Host key verification failed"
                    sh 'mkdir -p ~/.ssh && ssh-keyscan -H 54.169.12.75 >> ~/.ssh/known_hosts'

                    // Transfer file dengan SCP ke path tujuan di server AWS
                    sh 'scp -i $AWS_SSH_KEY -r ./build/ $SSH_USER@54.169.12.75:/home/ubuntu/my-react-app/'

                    // SSH ke server AWS dan jalankan aplikasi React
                    sh 'ssh -i $AWS_SSH_KEY $SSH_USER@54.169.12.75 << EOF\n' +
                       'sudo cp -r /home/ubuntu/my-react-app/build/* /var/www/my-react-app/\n'
                       'EOF'

                    echo "Aplikasi berhasil dideploy di server AWS."
                }
            } catch (Exception e) {
                currentBuild.result = 'FAILURE'
                throw e
            }
        }
    }
}