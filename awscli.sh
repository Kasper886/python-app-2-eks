#-----------------------#
# Install AWS CLI       #
#                       #
# Created: 08.11.2021   # 
# Owner: Alex Largman   # 
#-----------------------#


#!/bin/bash
#Install AWS CLI
sudo apt install -y zip unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
