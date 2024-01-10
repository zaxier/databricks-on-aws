output "vpc_id" {
  value = module.vpc.vpc_id
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "network_config" {
  value = {
    vpc_id                    = module.vpc.vpc_id
    default_security_group_id = module.vpc.default_security_group_id
    public_subnets            = module.vpc.public_subnets
    private_subnets           = module.vpc.private_subnets
  }

}