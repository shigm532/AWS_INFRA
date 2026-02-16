##### SG FOR BASTION HOST ****

resource "aws_security_group" "bastion_sg" {
  name   = "${var.environment}-bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH from my laptop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#### SG For APP #####

resource "aws_security_group" "app_sg" {
  name   = "${var.environment}-app-sg"
  vpc_id = var.vpc_id
}

##### ALLOW Access of 22 port  From Bastion Source SG  to APP SG ######

resource "aws_security_group_rule" "app_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.app_sg.id
}


### Internal & External  APP HTTP Access #### 

resource "aws_security_group_rule" "app_http_internal" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "app_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}




