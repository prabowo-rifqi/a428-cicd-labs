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
    }
}