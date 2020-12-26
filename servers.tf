
# Create rsa pub key for ssh
resource "aws_key_pair" "ssh_rsa_key" {
  key_name   = "ssh_rsa_key"
  public_key = var.my_rsa_pub_key
  
} 


# Create builder instance
resource "aws_instance" "builder" {
  ami = var.image_id
  instance_type = var.inst_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_webtomcat.id]
  key_name = aws_key_pair.ssh_rsa_key.key_name
  user_data = <<EOF
#!/bin/bash
sudo apt update && apt -y upgrade apt install -y awscli
export AWS_ACCESS_KEY_ID=${var.my_access_key}
export AWS_SECRET_ACCESS_KEY=${var.my_secret_key}
export AWS_DEFAULT_REGION=${var.deploy_region}
EOF
}


# Create prod instance
resource "aws_instance" "server2" {
  ami = var.image_id
  instance_type = var.inst_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_webtomcat.id]
  key_name = aws_key_pair.ssh_rsa_key.key_name
  user_data = <<EOF
#!/bin/bash
sudo apt update && apt -y upgrade apt install -y awscli
export AWS_ACCESS_KEY_ID=${var.my_access_key}
export AWS_SECRET_ACCESS_KEY=${var.my_secret_key}
export AWS_DEFAULT_REGION=${var.deploy_region}
EOF
  
}