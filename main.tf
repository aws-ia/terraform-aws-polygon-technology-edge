module "vpc" {
  source = "./modules/vpc"

  /**
    vpc_cidr_block
    vpc_name_tag
    az
    lan_subnets
    lan_subnets_name_tag
    public_subnets
    public_subnets_name_tag
    nat_gateway_name_tag
    default_route_name_tag
  */
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id

  ssh_key_name = var.ssh_key_name
  ssh_public_key = var.ssh_public_key

  admin_public_ip = var.admin_ip
  account_id= var.account_id

  /**
    internal_sec_gr_name_tag
    region
  */
}

module "s3" {
  source = "./modules/s3"
  vpc_id = module.vpc.vpc_id

  /**
    bucket_name_tag
    bucket_name
  */
}

module "instances" {
  source = "./modules/instances"

  count = 4
  node_index = count.index
  ssh_key_name = module.security.ssh_key_name
  internal_subnet = module.vpc.internal_subnets[count.index]
  internal_sec_groups = [module.security.internal_sec_group_id]
  user_data_base64 = module.user_data[count.index].polygon_edge_node
  instance_iam_role = module.security.ec2_to_assm_iam_policy_id
  az = module.vpc.av_zones[count.index]

  depends_on = [module.bastion_instance.instance_dns_name]
  /**
    instance_type
    user_data_base64
    ebs_root_name_tag
    instance_name
    instance_interface_name_tag
    chain_data_ebs_volume_size
    chain_data_ebs_name_tag
  */
}
module "bastion_instance" {
  source = "./modules/instances"

  ssh_key_name = module.security.ssh_key_name
  internal_subnet = module.vpc.external_subnets[0]
  internal_sec_groups = [module.security.bastion_public_id]
  instance_iam_role = module.security.ec2_to_assm_iam_policy_id

  instance_name = "Polygon_Edge_Bastion"
  instance_type = "t2.micro"
  polygon_edge_instance_type = false
  user_data_base64 = module.user_data[0].bastion
}

module "user_data" {
  source = "./modules/user-data"

  count = 4
  bastion_private_key = var.BASTION_PRIV_KEY
  node_name = "node${count.index}"
  controller_dns =  module.bastion_instance.instance_dns_name

  // Chain options
  premine = var.premine

  // Server non-required options
  /**
  max_slots
  block_time
  prometheus_address
  block_gas_target
  nat_address
  dns_name
  price_limit
  */

  // Chain non-required options
  /**
    chain_name
    chain_id
    block_gas_limit
    epoch_size
  */

  /**
    total_nodes
    polygon_edge_dir
    ebs_device
    assm_path 
    assm_region
    s3_bucket_name
  */
}

module "alb" {
  source = "./modules/alb"

  public_subnets = module.vpc.external_subnets
  alb_sec_group = module.security.jsonrpc_sec_group_id
  vpc_id = module.vpc.vpc_id
  node_ids = module.instances[*].instance_ids

/**
  nodes_nlb_name
  nodes_nlg_name_tag
  nodes_nlb_targetgroup_name
  nodes_nlb_targetgroup_port
  nodes_nlb_targetgroup_proto
  nodes_nlb_listener_port
*/  
}