pipeline {
    agent any
    stages {
        stage ('Build Backend') {
            steps {
                sh 'mvn clean pachage -DskipTests=true'
            }
        }
    }
}