# Create separate VPC
resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "vpc1"
    }
}

# Create IGW
resource "aws_internet_gateway" "internet_gw" {
    vpc_id = aws_vpc.vpc1.id
    tags = {
        Name = "internet_gw"
    }
}

# Create route table
resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.vpc1.id
    
    route {
        cidr_block = "0.0.0.0/0"   //reach any address
        gateway_id = aws_internet_gateway.internet_gw.id //use gateway for internet
    }
    
    tags = {
        Name = "pub_rt"
    }
}

# Create public subnet for Boxfuse project
resource "aws_subnet" "bf_pub_subnet_1" {
    vpc_id = aws_vpc.vpc1.id
    //cidr_block = "10.0.1.0/24"
    cidr_block = cidrsubnet(aws_vpc.vpc1.cidr_block,4,1) //subnet in region "a" availability zone
    map_public_ip_on_launch = "true"
    availability_zone = var.deploy_region
    
    tags = {
        Name = "bf_pub_subnet_1"
    }
}

# Create public subnet association with the routing table
resource "aws_route_table_association" "bf_rta_pub_subnet_1"{
    subnet_id = aws_subnet.bf_pub_subnet_1.id
    route_table_id = aws_route_table.pub_rt.id
}


# Create security rule
resource "aws_security_group" "allow_ssh_and_webtomcat" {
  name        = "allow_ssh_and_webtomcat"
  description = "Allow traffic for ssh and web"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "Incoming ssh at 22 from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["84.201.180.72/0"] //my ip
  }

  ingress {
    description = "Incoming tcp at 8080 from everywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outcoming traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_and_webtomcat"
  }
}