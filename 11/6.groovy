pipeline {
    agent any
    stages {
        stage('Terrascan') {
            steps {
                sh 'terrascan scan -i terraform --non-recursive'
            }
        }
    }
}
