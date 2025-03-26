#!/bin/bash
echo "Stopping Flask App Container"
docker stop flask-app || true
docker rm flask-app || true
