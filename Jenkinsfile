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
                SONAR_URL = "http://3.237.75.32:9000"
            }
            steps {
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONARQUBE_TOKEN')]) {
                    sh 'mvn sonar:sonar -Dsonar.login=$SONARQUBE_TOKEN -Dsonar.host.url=${SONAR_URL}'
                }
            }
        }
        stage('Build Application') {
            steps {
                sh 'mvn package'
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
                    sh 'docker run -d -p 8090:8080 --name spring-boot-app kiranks998/spring-boot-app'
                }
            }
        }
    }
    
    post {
        always {
            script {
                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
                def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
                def body = """
                <html>
                <body>
                <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                <h2>${jobName} - Build ${buildNumber}</h2>
                <div style="background-color: ${bannerColor}; padding: 10px;">
                <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                </div>
                <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                </div>
                </body>
                </html>
                """
                emailext (
                    subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                    body: body,
                    to: 'kirans3989@gmail.com',
                    from: 'kirans3989@example.com',
                    replyTo: 'kirans3989@example.com',
                    mimeType: 'text/html',
                    attachmentsPattern: 'image.html'
                )
            }
        }
    }
}
