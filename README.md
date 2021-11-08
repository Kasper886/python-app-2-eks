# AWS EKS cluster creation by Terraform and python application deploying
Thie repo demonstrates how to create AWS EKS cluster by means of IaaC Terraform and deploy python web application to it. 
Below you can find the diagram that illustrates created cluster.

![Image alt](https://github.com/Kasper886/WaveProject/blob/master/EKS-Cluster/files/diagram3.png)

## Summary
### Network
1. Dedicated VPC
2. 2 public subnets in 2 availability zones A and B
3. 2 private subnets in 2 availability zones A and B
4. Internet gateway for Future use
5. NAT gateway to get access for private instances for Future use
6. Route Tables
7. Route Table Association

### Nodes
1. Worker nodes in private subnets
2. Scaling configuration - desired size = 2, max size = 10, min_size = 1
3. Instances type - spot instances t3.small

### IAM Role & Policies
1. Cluster Role - Let EKS permission to create/use aws resources by cluster.
2. Policy - [Cluster_Policy](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSClusterPolicy)
3. Node Group Role - Let EC2 permission to create/use aws resources by instances.
4. Policy - [Worker_Node](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSWorkerNodePolicy)
5. Policy - [EKS_CNI](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKS_CNI_Policy)
6. Policy - [Registry_Read](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEC2ContainerRegistryReadOnly)

## How to do
You should have terraform on board and AWS credentials to get access to your AWS account.

### 1. Export AWS credentials and your default region (I worked in us-east-1 region)
```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxx
export AWS_DEFAULT_REGION=us-east-1
```
### 2. Clone repository and start the Terraform script
```
git clone https://github.com/Kasper886/python-app-2-eks.git
```
```
cd python-app-2-eks/
```
### 3. Install Docker, Python, Flask
If you want to build the Docker image or run the application on your own server, you should install Docker, Python and Flask.
Otherwise you can skip this step and move to step 4. Then use ready Docker image from Dockerhub.

a) change access to bash files
```
chmod 744 DockerSetup.sh
chmod 744 PythonFlaskSetup.sh
```
b) Then run these files
```
./DockerSetup.sh
```
```
./PythonFlaskSetup.sh
```
c) Build the Docker image and push to Dockerhub<br/>
If you have an error Permision dinied, use sudo with the docker commands.
```
docker build --tag <YourDockerHub>/python-docker .
```
Where YourDockerHub - your Docker Hub account name you created before. If not, you can do it [here](https://hub.docker.com/)
```
docker login
```
The system will ask your user name and password from your Dockerhub account
```
docker images
```
Check which image you created.
```
docker push <YourDockerHub>/python-docker:latest
```
If you didn't indicate version of your image, it will be latest. 
When ready, go to EKS cluster creation.

### 4. Run EKS cluster
If you don't still have terraform, run this command
```
chmod 744 terraform.sh
./terraform.sh
```
```
cd terraform
```
```
terraform init
```
```
terraform plan
```
```
terraform apply -auto-approve
```
This can take up to 20 minutes.

If you want to scale your node group, you need (the command to install these tools is bellow):
1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
2. [EKS CTL](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
3. [Kube CTL](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

Also, you need it to deploy the application to EKS cluster. To install these tools run the following command
```
chmod 744 ../aws.sh
../aws.sh
```

Then run the following command to "login" to your EKS cluster:

aws eks update-kubeconfig --name clusterName --region AWS region

  Where clusterName is name of your cluster (eks), AWS region - region of AWS (us-east-1)
```
aws eks update-kubeconfig --name eks --region us-east-1
```

Then make scaling:

eksctl scale nodegroup --cluster=clusterName --nodes=4 --name=nodegroupName

  Where clusterName is name of your cluster (wave-eks), nodegroupName - name of your group name (nodes-01)
```
eksctl scale nodegroup --cluster=wave-eks --nodes=4 --name=nodes-01
```

## Deployment
I will use my Docker image kasper86/python-docker:latest
Let's create the deployment
```
kubectl create deployment python-app --image kasper86/python-docker:latest
```
To get access to deployment we need external port and the LoadBalancer that provides dns name
```
kubectl expose deployment python-app --type=LoadBalancer --port 5000
```
To make sure it works, run the following commands
```
kubectl get pods
```
```
kubectl get deploy
```
```
kubectl get svc
```
These commands allow to check running pods, deployment and created service. When you finish checking, delete them
```
kubectl delete service python-app
```
```
kubectl delete deploy python-app
```

## Finally delete EKS cluster
```
terraform destroy -auto-approve
```

## Demo

https://user-images.githubusercontent.com/51818001/139727318-5aeb08dd-3e20-45d3-a59d-a0e4a39e98ac.mp4

## It works!
![itworks](https://user-images.githubusercontent.com/51818001/140783275-f5ccdc8c-f6ec-4494-8937-9259b55ad62f.png)
