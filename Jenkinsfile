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
                    sh "${scannerHome}/bin/sonar-scanner -e -Dsonar.projectKey=DeployBackEnd -Dsonar.host.url=http://localhost:9000 -Dsonar.login=dfe24e7f69a11dd95ec05de223428ae64ac97e26 -Dsonar.java.binaries=target -Dsonar.coverage.exclusions=**/.mvn/**,**/src/test/**,**/model/**,**Application.java"
                }
            }
        }
        stage("Quality Gate") {
            steps {
                sleep(10)
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Deploy Backend") {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'TomcatLogin', path: '', url: 'http://localhost:8080/')], contextPath: 'tasks-backend', war: 'target/tasks-backend.war'
            }
        }
        stage("Teste de API") {
            steps {
                dir('api-test') {
                    git credentialsId: 'github_login', url: 'https://github.com/caio-henrique/tasks-api-test.git'
                    sh 'mvn clean test'
                }
            }
        }
        stage("Deploy Frontend") {
            steps {
                dir('frontend') {
                    git credentialsId: 'github_login', url: 'https://github.com/caio-henrique/tasks-frontend.git'
                    sh 'mvn clean package'
                    deploy adapters: [tomcat9(credentialsId: 'TomcatLogin', path: '', url: 'http://localhost:8080/')], contextPath: 'tasks', war: 'target/tasks.war'
                }
            }
        }
        stage("Teste Funcional") {
            steps {
                dir('functional-test') {
                    git credentialsId: 'github_login', url: 'https://github.com/caio-henrique/tasks-functional-test.git'
                    sh 'mvn clean test'
                }
            }
        }
        stage("Deploy Prod") {
            steps {
                sh 'docker-compose build'
                sh 'docker-compose up -d'
            }

        }
        stage("Health Check") {
            steps {
                sleep(10)
                dir('functional-test') {
                    sh 'mvn verify -Dskip.surefire.tests'
                }
            }
        }
    }
    post {
        always {
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml, api-test/target/surefire-reports/*.xml, functional-test/target/surefire-reports/*.xml, functional-test/target/failsafe-reports/*.xml'
        }
    }
}

