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

  /**
    internal_sec_gr_name_tag
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
  ssh_key_name = "devops-zex"
  internal_subnet_id = module.vpc.internal_subnets[0].id
  internal_sec_groups = [module.security.internal_sec_group_id]
  user_data_base64 = module.user_data[count.index].polygon_edge_node
  instance_iam_role = module.security.ec2_to_assm_iam_policy_id
  /**
    instance_type
    user_data_base64
    az
    ebs_root_name_tag
    instance_name
    instance_interface_name_tag
    chain_data_ebs_volume_size
    chain_data_ebs_name_tag
  */
}
module "bastion_instance" {
  source = "./modules/instances"

  ssh_key_name = "devops-zex"
  internal_subnet_id = module.vpc.external_subnets[0].id
  internal_sec_groups = [module.security.bastion_public_id]

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

  /**
    polygon_edge_dir
    ebs_device
    assm_path 
    assm_region
  */
}