# mediawiki-deployment-tw
Mediawiki deployment using aws, terraform and ansible for configurion management

Steps:<br>
a) Clone the repository and install terraform<br>
b) Create AWS IAM user and assign it EC2, S3, VPC and DynamoDB full-access with programatic access<br>
c) configure your aws cli using accesskey and secret access key or you can use assume role approach<br>
d) go to "global/" directory and run "terraform init" then "terraform apply --auto-approve" to apply the changes - this is for managing the terraform state file at remote s3 backend and enable locking for state file using dynamoDB. Note: This project should only be executed once<br>
e) run cd .. <br>
f) go to "EC2/" directory using cd EC2/
g) run "ssh-keygen -f key" to create the public file to generate instance key pair on aws cloud
h) There will 2 files public and private key called as key and key.pub
j) rename the file key as key.pem using "mv key key.pem" then provide it permission "chmod 400 key.pem".
k) update the vars.tf to change the no of app instances "app_instances" and "dev_cidrs" range to allow ssh on server through Security Groups<br>
l) run "terraform init"<br>
m) run "terraform plan"<br>
o) run "terraform apply --auto-approve"<br>
<br>
Architecture Overview:<br>
There is a VPC with public and private subnet, classic load balancer configure to work on port 80 with default 2 instances configured to server the application. User browse the dns of classic load balancer to access the mediawiki application. For backend and application there is ansible playbook which configure and install necessary dependency on servers.<br>
<br>
Terraform Output: <br>
Output will give you the the classsic load balancer dns to access application

Note: EC2/mediawiki_deployment.yml is the ansible configuration to configure and deploy mediawiki app, Terraform config code in EC2, Network(vpc), CLB Modules
