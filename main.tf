provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "AZ" {
  state = "available"
}

module "Network" {
  source = "./Network"

  envname = "tw-${var.envname}"

  AZ = [
    data.aws_availability_zones.AZ.names[0],
    data.aws_availability_zones.AZ.names[1]
  ]
  vpc_cidr     = var.vpc_cidr
  public_cidr  = var.public_subnet
  private_cidr = var.private_subnet
}

module "S3" {
  source = "./S3"
  deployment_scripts_bucket = var.deployment_scripts_bucket
}

module "EC2" {
  depends_on = [module.S3]
  source  = "./EC2"
  envname = var.envname

  vpc_id            = module.Network.vpc_id
  public_subnet     = module.Network.public_subnet
  app_instances     = var.app_instances
  dev_allowed_cidrs = var.dev_cidrs
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  deployment_script = "https://${module.S3.deployment_scripts_bucket}.s3.amazonaws.com/${module.S3.deployment_script}"
}

module "CLB" {
  source           = "./CLB"
  envname          = var.envname
  vpc_id           = module.Network.vpc_id
  public_subnet    = module.Network.public_subnet
  clbsg            = module.EC2.clbsg
  app_instance_ids = module.EC2.app_instance_ids
}

output "app_instances" {
  value = module.EC2.app_instance_ids
}

output "app_url" {
  value = "${module.CLB.clb_dns}"
}
