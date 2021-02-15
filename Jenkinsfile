pipeline {
    agent any
    stages {
        stage ('Build Backend') {
            steps {
                sh 'mvn clean package -DskipTests=true'
            }
        }
        stage ('Testes unitários') {
            steps {
                sh 'mvn test'
            }
        }
        stage ('Análise Sonar') {
            environment {
                scannerHome = tool 'Sonar_Scanner'
            }
            steps {
                withSonarQubeEnv('Sonar') {
                    sh "${scannerHome}/bin/sonar-scanner -e -Dsonar.projectKey=DeployBackEnd -Dsonar.host.url=http://localhost:9000 -Dsonar.login=f0eb6275a40ede19327d7043229bb1b2bd6b9c84 -Dsonar.java.binaries=target -Dsonar.coverage.exclusions=**/.mvn/**,**/src/test/**,**/model/**,**Application.java"
                }
            }
        }
        stage ('Quality Gate') {
            steps {
                sleep(10)
                timeout(time, 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}

