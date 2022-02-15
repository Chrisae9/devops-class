pipeline {
    agent {
        label 'kiwi'
    }
    environment {
        DOCKER_CREDS = credentials('docker')
        // DOCKER_CREDS, DOCKER_CREDS_USR, DOCKER_CREDS_PSW
    }
    stages {
        stage('Build') {
            steps {
                echo 'building'
                sh("docker build -t $DOCKER_CREDS_USR/website:latest .")
            }
        }
        stage('Deploy') {
            steps {
                echo 'deploying'
            }
        }
        stage('Docker Push') {
            agent any
            steps {
                echo 'pushing'
    
                    sh("docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW")
                    sh "docker push $DOCKER_CREDS_USR/website:latest"
                }
            }
        }
    }
}
