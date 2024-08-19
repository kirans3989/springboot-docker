pipeline {
    agent any
    tools {
        maven 'maven3'
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
        
  stage('Static Code Analysis') {
    environment {
        SONAR_URL = "http://35.172.250.189:9000"
    }
    steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONARQUBE_TOKEN')]) {
            sh 'ls -la' // List files to confirm directory structure
            sh 'pwd'    // Print working directory
            sh 'mvn sonar:sonar -Dsonar.login=$SONARQUBE_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
    }
}


        stage('Build Application') {
            steps {
                sh 'mvn package'
            }
        }
        /*
        stage('Publish Artifact') {
            steps {
                withMaven(globalMavenSettingsConfig: 'settings-maven', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh 'mvn deploy'
                }
            }
        } */
        stage('Docker Build & Tag') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker') {
                        sh 'docker build -t kiranks998/spring-boot-app:latest .'
                    }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o image.html kiranks998/spring-boot-app:latest'
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker') {
                        sh 'docker push kiranks998/spring-boot-app:latest'
                    }
                }
            }
        }

       stage('Run Docker Container') {
    steps {
        script {
            // Ensure Docker is running and accessible
            sh 'docker --version'

            // Run the Docker container
            sh 'docker run -d -p 8090:8080 --name spring-boot-app kiranks998/spring-boot-app'
        }
    }
}
        
        }
    }

