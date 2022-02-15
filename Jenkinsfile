pipeline {
    agent {
        label 'Kiwi'
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
                sh("docker run --rm --name website $DOCKER_CREDS_USR/website:latest")
            }
        }
        stage('Docker Push') {
            steps {
                echo 'pushing'
                    sh("docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW")
                    sh "docker push $DOCKER_CREDS_USR/website:latest"
            }
        }
    }
}

