#!/bin/bash
echo "Stopping existing container (if any)..."
if [ "$(docker ps -q -f name=flask-app)" ]; then
    docker stop flask-app
    docker rm flask-app
fi

echo "Pulling latest Docker image from ECR..."
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 205930641078.dkr.ecr.ap-southeast-1.amazonaws.com/flask-app-pipeline
docker pull 205930641078.dkr.ecr.ap-southeast-1.amazonaws.com/flask-app-pipeline:latest

echo "Starting new container..."
docker run -d --name flask-app -p 5000:5000 205930641078.dkr.ecr.ap-southeast-1.amazonaws.com/flask-app-pipeline:latest
