pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        PYTHON = 'C:\\Users\\krish\\AppData\\Local\\Programs\\Python\\Python312\\python.exe'
        DOCKER = 'C:\\Users\\krish\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
        IMAGE_NAME = 'jenkins-cicd-demo'
        CONTAINER_NAME = 'cicd-container-jenkins'
    }

    stages {
        stage('Verify Tools') {
            steps {
                bat '"%PYTHON%" --version'
                bat '"%DOCKER%" --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat '"%PYTHON%" -m pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                bat 'if not exist test-results mkdir test-results'
                bat '"%PYTHON%" -m pytest -v --junitxml=test-results/results.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '"%DOCKER%" build -t %IMAGE_NAME%:%BUILD_NUMBER% -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Deploy Container Locally') {
            steps {
                bat '"%DOCKER%" rm -f %CONTAINER_NAME% || exit /b 0'
                bat '"%DOCKER%" run -d --name %CONTAINER_NAME% -p 5001:5000 %IMAGE_NAME%:latest'
            }
        }
    }

    post {
        always {
            junit testResults: 'test-results/*.xml',
                  allowEmptyResults: true
        }

        success {
            echo 'CI/CD Pipeline completed successfully!'
            echo 'Application deployed on port 5001'
        }

        failure {
            echo 'Pipeline failed. Check the console output.'
        }
    }
}