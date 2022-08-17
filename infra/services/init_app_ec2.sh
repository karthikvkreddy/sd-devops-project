#!/bin/bash

Environment=${1}

# Install Application Dependencies
yum install -y dos2unix telnet 

# Install Nodejs 
yum install -y nodejs npm

# Get Application code
aws s3 cp s3://mean-stack-app-2022/services/$1/mean-prod.zip ~
unzip ~/mean-prod.zip -d /opt/app-root/ > /dev/null
rm -f ~/mean-prod.zip

# Get Environment Variables
aws s3 cp s3://mean-stack-app-2022/security/$1/.env /opt/app-root/api/.env 

# Run application
chown -R ec2-user:ec2-user /opt/app-root
su ec2-user -c "cd /opt/app-root/api && node api.bundle.js" &