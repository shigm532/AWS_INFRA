#### AMI DATA BLOCK ###

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


#### Bastion Configuration ####

resource "aws_instance" "bastion" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" 
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-bastion"
  }
}

##### APP Configuration ####

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.app_sg_id]

  tags = {
    Name = "${var.environment}-app-server"
  }
}


###### IAM CONFIGURATION ##### 

iam_instance_profile = var.instance_profile_name



