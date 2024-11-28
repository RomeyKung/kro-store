pipeline {
    agent any

    environment {
        REMOTE_HOST     = 'ubuntu@54.197.82.79'
        SSH_CREDENTIALS = 'sshaws'
        BASE_URL        = "http://54.197.82.79"
        DOCKER_CREDENTIALS = credentials('owendocker')
    }
    
    stages {
        stage('copy repository') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Wipupat-Chomthaworn/KRO-GameStore.git']])
                sh "echo BASE_URL=${BASE_URL} > .env"
                sh "echo OMISE_PUBLIC_KEY=pkey_test_5yy91xv84zjnnitvdw0 > kro-backend/.env"
                sh "echo OMISE_SECRET_KEY=skey_test_5wmco0oh1cfnliaoszv >> kro-backend/.env"
                sh "echo SECRET_KEY=s_kroKey_back_i2tpohbojgagageq3u4ihryh >> kro-backend/.env"
            }  
        }
        stage('Build Image and Push to Docker Hub') {
            steps {
                script {
                    sh 'echo $DOCKER_CREDENTIALS_PSW | docker login --username $DOCKER_CREDENTIALS_USR --password-stdin'
                    sh 'docker build -t mighth/kro-nginx:latest ./nginx'
                    sh 'docker build -t mighth/kro-nuxt:latest .'
                    sh 'docker build -t mighth/kro-golang:latest ./kro-backend'
                    sh 'docker push mighth/kro-nginx:latest'
                    sh 'docker push mighth/kro-nuxt:latest'
                    sh 'docker push mighth/kro-golang:latest'
                }
            }
        }
        stage('Clear Environment') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    sh "ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'rm -rf kro-store'"
                    sh "ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'docker stop \$(docker ps -a -q) || true'"
                    sh "ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'docker rm \$(docker ps -a -q) || true'"
                    sh "ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'docker rmi \$(docker images -q) || true'"
                }
            }
        }
        stage('Docker Pull') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    sh "ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'docker-compose pull'"
                }
            }
        }
        stage('Build on Remote Server') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    sh "ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'docker-compose up -d --build'"

                }
            }
        }
    }
}
