node {
    docker.image('node:16-buster-slim').inside('--network host -p 3000:3000') {
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
        stage('Manual Approval') {
            input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed', parameters: [
                choice(name: 'Action', choices: ['Proceed', 'Abort'], description: 'Pilih apakah ingin melanjutkan ke tahap Deploy atau menghentikan eksekusi pipeline')
            ]
        }
        stage('Deploy') {
            try {
                sh './jenkins/scripts/deliver.sh'

                echo "Aplikasi berhasil dideploy. Menunggu selama 1 menit sebelum melanjutkan..."
                sh 'sleep 60'

                sh './jenkins/scripts/kill.sh'
            } catch (Exception e) {
                currentBuild.result = 'FAILURE'
                throw e
            }
        }
    }
}