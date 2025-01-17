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
                // Pastikan file deliver.sh berada dalam folder 'scripts'
                // sh './jenkins/scripts/deliver.sh'

                // Setelah build selesai, lakukan transfer file ke server AWS
                sh 'scp -i /home/ssh -r ./build/ ubuntu@<54.169.12.75>:/home/ubuntu/my-react-app/'

                // SSH ke server AWS dan jalankan aplikasi React
                sh 'ssh -i /path/to/your-aws-key.pem ubuntu@<your-aws-server-ip> << EOF\n' +
                    'cd /home/ubuntu/my-react-app\n' +
                    'npm install --production\n' +
                    'npm run start &\n' +  // Menjalankan aplikasi React dalam mode produksi
                    'EOF'

                echo "Aplikasi berhasil dideploy di server AWS."
            } catch (Exception e) {
                currentBuild.result = 'FAILURE'
                throw e
            }
        }
    }
}