pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-southeast-1'  
        ECR_REPO = '205930641078.dkr.ecr.ap-southeast-1.amazonaws.com/flask-app-pipeline'  // ECR Repo URL
        IMAGE_TAG = 'latest'
        CODEDEPLOY_APP_NAME = 'flask-app-deploy'
        CODEDEPLOY_GROUP_NAME = 'flask-deployment-group'
        S3_BUCKET = 'manav711'  
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/manav-makhija77/flask-hello-world-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                 sh 'docker build -t "${ECR_REPO}:${IMAGE_TAG}" .'
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                   withAWS(credentials: 'aws-ecr-credentials', region: 'ap-southeast-1') {
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin "${ECR_REPO}"
                    '''
                    }
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                     sh 'docker push "${ECR_REPO}:${IMAGE_TAG}"'
                }
            }
        }
            stage('Create Deployment ZIP') {
            steps {
                script {
                    // Package the app into a ZIP file, excluding unnecessary files like .git and Jenkinsfile
                    sh '''
                    zip -r flask-app-deployment.zip . -x "*.git*" -x "Jenkinsfile"
                    '''
                }
            }
        }
        
        stage('Upload Deployment Package to S3') {
            steps {
                script {
                    // Upload the deployment package to S3
                    sh '''
                    aws s3 cp flask-app-deployment.zip s3://${S3_BUCKET}/flask-app-deployment.zip --region ${AWS_REGION}
                    '''
                }
            }
        }
        stage('Deploy to EC2 using CodeDeploy') {
            steps {
                script {
                    // Trigger the deployment using AWS CodeDeploy from S3
                    sh """
                        aws deploy create-deployment \
                            --application-name ${CODEDEPLOY_APP_NAME} \
                            --deployment-group-name ${CODEDEPLOY_GROUP_NAME} \
                            --revision revisionType=S3,s3Location={bucket=${S3_BUCKET},key=flask-app-deployment.zip,bundleType=zip} \
                            --region ${AWS_REGION}
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs() 
        }
        success {
            echo "Build & Push to AWS ECR Successful ✅"
        }
        failure {
            echo "Build & Push Failed ❌"
        }
    }
}
