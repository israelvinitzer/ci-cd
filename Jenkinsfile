pipeline {
    agent {
        label "jenkins-agent"
    }
    tools{
        jdk "Java17"
        maven 'Maven3'
    }
    environment{
        APP_NAME = "ci-cd"
        RELEASE = "1.0.0"
        DOCKER_USER = "israel.vinitzer"
        DOCKER_PASS = "Ehmzhssr1"
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"

    }
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from SCM') {
            steps {
                git branch:'main', credentialsId: 'github',url: "https://github.com/israelvinitzer/ci-cd"
            }
        }
        stage('Build Applicaton') {
            steps {
                sh "mvn clean package"
            }
        }
        stage('Test Application') {
            steps {
                sh "mvn test"
            }
        }
        
        stage('Sonarqube analysis') {
            steps {
                script{
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                script{
                    docker.withRegistry('',DOCKER_PASS){
                        docker_image = docker.build "${IMAGE_NAME}"
                    }
                    
                    docker.withRegistry('',DOCKER_PASS){
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }
    }
                
    }
}
