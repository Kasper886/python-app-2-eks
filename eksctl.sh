#-----------------------#
# Install EKS CTL       #
#                       #
# Created: 08.11.2021   # 
# Owner: Alex Largman   # 
#-----------------------#

#!/bin/bash
#Install EKS CTL
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /bin
eksctl version
