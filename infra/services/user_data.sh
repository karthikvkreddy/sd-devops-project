#!/bin/bash -xe

export HOME=/root

# Install application dependency
sudo yum install -y dos2unix unzip

# Install AWS CLI  
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

export PATH=/usr/local/bin:$PATH
source ~/.bash_profile

# Configure AWS CLI
mkdir -p ~/.aws
echo "[default]
region = us-east-1
output = json" > ~/.aws/config

#Run Initialization sh
aws s3 cp s3://mean-stack-app-2022/services/Dev/init_app_ec2.sh ~
chmod +x ~/init_app_ec2.sh
dos2unix ~/init_app_ec2.sh
~/init_app_ec2.sh Dev 2>&1 | tee ~/init.log &