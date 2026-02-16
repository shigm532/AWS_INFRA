#provider "aws" {
#  region = "us-east-1"
#}


################ Connecting to VPC MODULE ###############

module "vpc" {

  source = "../../modules/vpc"
  
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "dev-vpc"
  
  public_subnet_1 = "10.0.1.0/24"
  public_subnet_2 = "10.0.2.0/24"

  private_subnet_1 = "10.0.3.0/24"
  private_subnet_2 = "10.0.4.0/24"

  environment = "dev"
   
  az_1 = "us-east-1a"
  az_2 = "us-east-1b"
}


##############  SECURITY GROUP ##############

module "security" {
  source = "../../modules/security"

  environment = "dev"
  vpc_id      = module.vpc.vpc_id
  my_ip       = "49.207.149.7/32"
}


############### Connecting to EC2 MODULE ################

module "ec2" {
  source = "../../modules/ec2"

  environment = "dev"
  #ami_id = "ami-0c02fb55956c7d316"

  public_subnet_id  = module.vpc.public_subnet_1_id
  private_subnet_id = module.vpc.private_subnet_1_id

  bastion_sg_id = module.security.bastion_sg_id
  app_sg_id     = module.security.app_sg_id
  instance_profile_name = module.iam.instance_profile_name

}


#############  CALLING IAM MODULE #######

module "iam" {
  source      = "../../modules/iam"
  environment = "dev"
}


####### Monitoring Module ##### 

module "monitoring" {
  source = "../../modules/monitoring"

  environment      = "dev"
  app_instance_id  = module.compute.app_instance_id
}


##############  
