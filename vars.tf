# Define access and secret key for aws in variables
variable "my_aws_access_key" {
  default = "enter-your-access-key-here!!!!!!!!!!!!"
} 
variable "my_aws_secret_key" {
  default = "enter-your-secret-key-here!!!!!!!!!!!!"
} 

variable "my_rsa_pub_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAizlKykSxayQNA9PKrwT44VpirQSALkiYA9tbL39Am6zB25FeOWGXuIEVJHCT8bPhDuqISJJemOSZI5ps4EuoyBfnU/EdUQ8M+Tp3Fl8+PuEk85q41UdT/IJIWlUnrvd6HK9TIUPZWP795qcq8it6fSIvHBOp0q3AFIAejKxvCED4qSoUo5CAJwowXaGApjJi/19xtwf1tHeuaQE084NUCf/EPatXQo3Y2ntvSAkbaNlZnyS9bRMTXZyp9BS1jliby297uKpWnGyoeTNOyG4Euufx3CZxJFV6LIrrcNdLbAm/03WP5p2ODGa5Db8FzRCQw/e6E/YkSzFykNAaZmQz4w== rsa-key-20201104"
} 

# Define my bucket name in a variable
variable "my_bucket" {
  default = "s3://mybacket1.ufndtwocmeu.ru"
} 

# Define instance type in a variable
variable "inst_type" {
  default = "t2.micro"
} 

# Define region in a variable
variable "deploy_region" {
  default = "us-east-2"
} 

# EC2 AMI:  us-east-2	bionic	18.04 LTS	amd64	hvm:instance-store	release 20201211.1
variable "image_id" {
  default = "ami-0ee2e39b4d1c36cf4"
}