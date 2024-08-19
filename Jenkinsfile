pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    environment {
        SCANNER_HOME = tool 'SonarQube'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kirans3989/springboot-docker.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Unit-Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        
       stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' 
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectName=taskmaster \
                    -Dsonar.projectKey=taskmaster \
                    -Dsonar.java.binaries=target
                    '''
                }
            }
        }
        stage('Build Application') {
            steps {
                sh 'mvn package'
            }
        }
         Uncomment if needed
        stage('Publish Artifact') {
            steps {
                withMaven(globalMavenSettingsConfig: 'settings-maven', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh 'mvn deploy'
                }
            }
        } 
        stage('Docker Build & Tag') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker') {
                        sh 'docker build -t kiranks998/spring-boot-app:latest .'
                    }
                }
            }
        }
      /*  stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o image.html kiranks998/spring-boot-app:latest'
            }
        }*/
        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker') {
                        sh 'docker push kiranks998/spring-boot-app:latest'
                    }
                }
            }
        }
    }
}
