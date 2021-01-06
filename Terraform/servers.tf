
# Create rsa pub key for ssh
resource "aws_key_pair" "ssh_rsa_key" {
  key_name   = "ssh_rsa_key"
  public_key = var.my_rsa_pub_key
  
} 


# Create builder instance
resource "aws_instance" "builder" {
  ami = var.image_id
  availability_zone = var.deploy_az
  instance_type = var.inst_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_webtomcat.id]
  subnet_id = aws_subnet.bf_pub_subnet_1.id
  key_name = aws_key_pair.ssh_rsa_key.key_name

  #install python and boto, allow root coonection with pub key, clear pub key from aws scripts in authorized_keys, restart ssh
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository -y universe
sudo apt-add-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.9
sudo apt install -y python3-pip
sudo pip3 install boto3
sudo echo -e "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config
sudo echo -e "${var.my_rsa_pub_key}" > /root/.ssh/authorized_keys
sudo systemctl restart ssh || systemctl restart sshd
EOF

#add created instance to local ansible hosts config
provisioner "local-exec" {
    command = <<EOF
    #!/bin/bash
    sudo sed -i "/boxfuse_builder/d" "/etc/ansible/hosts" 
    sudo echo -e "[boxfuse_builder] \n${aws_instance.builder.public_ip} label=boxfuse_builder" >> /etc/ansible/hosts
    EOF
  }

}



# Create prod instance
resource "aws_instance" "prod" {
  ami = var.image_id
  availability_zone = var.deploy_az
  instance_type = var.inst_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_webtomcat.id]
  subnet_id = aws_subnet.bf_pub_subnet_1.id
  key_name = aws_key_pair.ssh_rsa_key.key_name

  #install python and boto, allow root coonection with pub key, clear pub key from aws scripts in authorized_keys, restart ssh
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository -y universe
sudo apt-add-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.9
sudo apt install -y python3-pip
sudo pip3 install boto3
sudo pip3 install docker
sudo echo -e "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config
sudo echo -e "${var.my_rsa_pub_key}" > /root/.ssh/authorized_keys
sudo systemctl restart ssh || systemctl restart sshd
EOF

//add created instance to local ansible hosts config
provisioner "local-exec" {
    command = <<EOF
    #!/bin/bash
    sudo sed -i "/boxfuse_prod/d" "/etc/ansible/hosts" 
    sudo echo -e "[boxfuse_prod] \n${aws_instance.prod.public_ip} label=boxfuse_prod" >> /etc/ansible/hosts
    sleep 60
    sudo ssh-copy-id -o StrictHostKeyChecking=no ubuntu@${aws_instance.builder.public_ip}
    sudo ssh-copy-id -o StrictHostKeyChecking=no ubuntu@${aws_instance.prod.public_ip}
    EOF
  }

}