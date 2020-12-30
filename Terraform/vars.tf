/*# Define access and secret key for aws in variables
variable "my_aws_access_key" {
  default = $MY_AWS_ACCESS_KEY
} 
variable "my_aws_secret_key" {
  default = $MY_AWS_SECRET_KEY
} 

variable "my_rsa_pub_key" {
  default = $MY_RSA_PUB_KEY
} */


# Define instance type in a variable
variable "inst_type" {
  default = "t2.micro"
} 

# Define region in a variable
variable "deploy_region" {
  default = "us-east-2"
} 

# Define availability zone in variable
variable "deploy_az" {
  default = "us-east-2a"
} 

# EC2 AMI:  eu-north-1	bionic	18.04 LTS	amd64	hvm:ebs-ssd	 release 20201211.1
variable "image_id" {
  default = "ami-0dd9f0e7df0f0a138"
}