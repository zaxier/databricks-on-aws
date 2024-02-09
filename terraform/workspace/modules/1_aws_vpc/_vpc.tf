data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name = "${var.aws_prefix}-vpc"
  cidr = var.cidr
  azs  = data.aws_availability_zones.available.names
  tags = var.tags

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  create_igw           = true

  public_subnets = [cidrsubnet(var.cidr, 3, 0)] # TODO: adjust to fit two workspaces later
  private_subnets = [cidrsubnet(var.cidr, 3, 1),
  cidrsubnet(var.cidr, 3, 2)] # TODO: adjust to fit two workspaces later

  # public_subnets = [cidrsubnet(var.cidr, 5, 0)]
  # private_subnets = [cidrsubnet(var.cidr, 5, 1),
  # cidrsubnet(var.cidr, 5, 2), cidrsubnet(var.cidr, 5, 3),
  # cidrsubnet(var.cidr, 5, 4)]

  manage_default_security_group  = true
  default_security_group_name    = "${var.aws_prefix}-sg"
  default_security_group_egress  = [{ cidr_blocks = "0.0.0.0/0" }]
  default_security_group_ingress = [{ description = "Allow all internal TCP and UDP", self = true }]

}

module "endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.4.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.default_security_group_id]

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      tags = {
        Name = "${var.aws_prefix}-s3-vpc-gw-endpoint"
      }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags = merge({
        Name = "${var.aws_prefix}-sts-vpc-interface-endpoint"
      }, var.tags)
    },
    kinesis-streams = {
      service             = "kinesis-streams"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags = {
        Name = "${var.aws_prefix}-kinesis-vpc-interface-endpoint"
      }
    },
  }
  tags = var.tags
}
