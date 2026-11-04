
pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        DOCKER = 'C:\\Users\\krish\\AppData\\Local\\Programs\\Docker\\Docker\\resources\\bin\\docker.exe'
        PYTHON = 'C:\\Users\\krish\\AppData\\Local\\Programs\\Python\\Python312\\python.exe'

        IMAGE_NAME = 'jenkins-cicd-demo'
        CONTAINER_NAME = 'cicd-container-jenkins'
    }

    stages {

        stage('Verify Tools') {
            steps {
                echo 'Checking Python installation...'
                bat '"%PYTHON%" --version'

                echo 'Checking Docker installation...'
                bat '"%DOCKER%" --version'

                echo 'Checking Docker Engine...'
                bat '"%DOCKER%" info'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing Python dependencies...'
                bat '"%PYTHON%" -m pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running automated tests...'

                bat 'if not exist test-results mkdir test-results'

                bat '"%PYTHON%" -m pytest -v --junitxml=test-results/results.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'

                bat '"%DOCKER%" build -t %IMAGE_NAME%:%BUILD_NUMBER% -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Deploy Container Locally') {
            steps {
                echo 'Removing previous container if it exists...'

                bat '"%DOCKER%" rm -f %CONTAINER_NAME% 2>nul || exit /b 0'

                echo 'Starting new application container...'

                bat '"%DOCKER%" run -d --name %CONTAINER_NAME% -p 5001:5000 %IMAGE_NAME%:latest'

                echo 'Checking running container...'

                bat '"%DOCKER%" ps'
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
            echo 'Open http://localhost:5001'
        }

        failure {
            echo 'Pipeline failed. Check the console output.'
        }
    }
}

