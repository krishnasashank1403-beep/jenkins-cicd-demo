
pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = 'jenkins-cicd-demo'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                echo 'Source code downloaded from GitHub'
            }
        }

        stage('Verify Tools') {
            steps {
                bat 'python --version'
                bat 'docker --version'
                bat 'docker info'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'python -m venv .venv-ci'
                bat '.venv-ci\\Scripts\\python.exe -m pip install --upgrade pip'
                bat '.venv-ci\\Scripts\\python.exe -m pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                bat '.venv-ci\\Scripts\\python.exe -m pytest -v --junitxml=pytest-results.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:build-%BUILD_NUMBER% .'
                bat 'docker image inspect %IMAGE_NAME%:build-%BUILD_NUMBER%'
            }
        }
    }

    post {
        always {
            junit testResults: 'pytest-results.xml',
                  allowEmptyResults: true
        }

        success {
            echo 'CI pipeline completed successfully!'
        }

        failure {
            echo 'CI pipeline failed. Check the console output.'
        }
    }
}
