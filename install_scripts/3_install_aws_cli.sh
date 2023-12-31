#!/bin/bash

# Check if aws cli is already installed
if [ -x "$(command -v aws)" ]; then
    echo "AWS CLI already installed"
    exit 0
fi

cd ~

# Check if awscliv2.zip file already exists
if [ -f "awscliv2.zip" ]; then
    echo "awscliv2.zip already exists"
else
    echo "Downloading awscliv2.zip"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
fi

# Check if aws/ folder already exists
if [ -d "aws" ]; then
    echo "aws/ folder already exists"
else
    echo "Unzipping awscliv2.zip"
    unzip awscliv2.zip
fi

./aws/install

chmod +x /usr/local/bin/aws

aws --version
