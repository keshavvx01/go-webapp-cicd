pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "keshavvx01/go-webapp-cicd"
        DOCKER_TAG = "latest"
        CONTAINER_NAME = "go-webapp-cicd"
    }

    tools {
        go 'go-1.22'
    }

    stages {
        stage('Test') {
            steps {
                sh 'go test ./...'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '/usr/bin/docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | /usr/bin/docker login -u "$DOCKER_USER" --password-stdin
/usr/bin/docker push $DOCKER_IMAGE:$DOCKER_TAG
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    /usr/bin/docker stop $CONTAINER_NAME || true
/usr/bin/docker rm $CONTAINER_NAME || true
/usr/bin/docker run -d -p 9090:9090 --name $CONTAINER_NAME $DOCKER_IMAGE:$DOCKER_TAG
                '''
            }
        }
    }
}

