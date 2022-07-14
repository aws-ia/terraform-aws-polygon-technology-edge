module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = ">= 1.4.1"

  name       = var.vpc_name
  cidr_block = var.vpc_cidr_block
  az_count   = 4

  subnets = {
    public = {
      netmask                   = 24
      nat_gateway_configuration = "all_azs"
    }

    private = {
      netmask      = 24
      route_to_nat = true
    }
  }

  vpc_flow_logs = {
    log_destination_type = "cloud-watch-logs"
    retention_in_days    = 180
  }
}

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = ">= 3.3.0"

  bucket_prefix = var.s3_bucket_prefix
  acl           = "private"
}

module "security" {
  source = "./modules/security"

  vpc_id                   = module.vpc.vpc_attributes.id
  account_id               = var.account_id
  s3_shared_bucket_name    = module.s3.s3_bucket_id
  ssm_parameter_id         = var.ssm_parameter_id
  region                   = var.region
  internal_sec_gr_name_tag = var.internal_sec_gr_name_tag
  alb_sec_gr_name_tag      = var.alb_sec_gr_name_tag
}

module "instances" {
  source = "./modules/instances"

  for_each = module.vpc.private_subnet_attributes_by_az

  internal_subnet             = each.value.id
  internal_sec_groups         = [module.security.internal_sec_group_id]
  user_data_base64            = module.user_data[each.key].polygon_edge_node
  instance_iam_role           = module.security.ec2_to_assm_iam_policy_id
  az                          = each.key
  instance_type               = var.instance_type
  instance_name               = var.instance_name
  ebs_root_name_tag           = var.ebs_root_name_tag
  instance_interface_name_tag = var.instance_interface_name_tag
  chain_data_ebs_volume_size  = var.chain_data_ebs_volume_size
  chain_data_ebs_name_tag     = var.chain_data_ebs_name_tag
}

module "user_data" {
  source = "./modules/user-data"

  for_each  = module.vpc.private_subnet_attributes_by_az
  node_name = "${var.node_name_prefix}-${each.key}"

  assm_path      = var.ssm_parameter_id
  assm_region    = var.region
  s3_bucket_name = module.s3.s3_bucket_id
  total_nodes    = length(module.vpc.private_subnet_attributes_by_az)

  polygon_edge_dir = var.polygon_edge_dir
  ebs_device       = var.ebs_device

  # Server configuration

  max_slots          = var.max_slots
  block_time         = var.block_time
  prometheus_address = var.prometheus_address
  block_gas_target   = var.block_gas_target
  nat_address        = var.nat_address
  dns_name           = var.dns_name
  price_limit        = var.price_limit

  #  # Chain configuration
  #  premine         = var.premine
  #  chain_name      = var.chain_name
  #  chain_id        = var.chain_id
  #  block_gas_limit = var.block_gas_limit
  #  epoch_size      = var.epoch_size
}

module "alb" {
  source = "./modules/alb"

  public_subnets      = [for _, value in module.vpc.public_subnet_attributes_by_az : value.id]
  alb_sec_group       = module.security.jsonrpc_sec_group_id
  vpc_id              = module.vpc.vpc_attributes.id
  node_ids            = [for _, instance in module.instances : instance.instance_id]
  alb_ssl_certificate = var.alb_ssl_certificate

  nodes_alb_name                    = var.nodes_alb_name_prefix
  nodes_alb_name_tag                = var.nodes_alb_name_tag
  nodes_alb_targetgroup_name_prefix = var.nodes_alb_targetgroup_name
}
