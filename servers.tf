
# Create rsa pub key for ssh
resource "aws_key_pair" "ssh_rsa_key" {
  key_name   = "ssh_rsa_key"
  public_key = var.my_rsa_pub_key
  
} 


# Create builder instance
resource "aws_instance" "builder" {
  ami = var.image_id
  //availability_zone = "eu-north-1a"
  instance_type = var.inst_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_webtomcat.id]
  subnet_id = aws_subnet.bf_pub_subnet_1.id
  key_name = aws_key_pair.ssh_rsa_key.key_name
  user_data = <<EOF
#!/bin/bash
sudo apt update && apt -y upgrade apt install -y awscli
export AWS_ACCESS_KEY_ID=${var.my_aws_access_key}
export AWS_SECRET_ACCESS_KEY=${var.my_aws_secret_key}
export AWS_DEFAULT_REGION=${var.deploy_region}
EOF
}


# Create prod instance
resource "aws_instance" "prod" {
  ami = var.image_id
  //availability_zone = "eu-north-1a"
  instance_type = var.inst_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_webtomcat.id]
  subnet_id = aws_subnet.bf_pub_subnet_1.id
  key_name = aws_key_pair.ssh_rsa_key.key_name
  user_data = <<EOF
#!/bin/bash
sudo apt update && apt -y upgrade apt install -y awscli
export AWS_ACCESS_KEY_ID=${var.my_aws_access_key}
export AWS_SECRET_ACCESS_KEY=${var.my_aws_secret_key}
export AWS_DEFAULT_REGION=${var.deploy_region}
EOF
  
}