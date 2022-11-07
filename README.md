<!-- BEGIN_TF_DOCS -->
<p align="center">
  <img src="https://raw.githubusercontent.com/0xPolygon/polygon-edge/develop/.github/banner.jpg" alt="Polygon Edge" width="100%">
</p>

# Polygon Edge AWS Terraform

Polygon Edge is a modular and extensible framework for building Ethereum-compatible blockchain networks.

To find out more about Polygon, visit the [official website](https://polygon.technology/).

### Documentation 📝

If you'd like to learn more about the Polygon Edge, how it works and how you can use it for your project,
please check out the **[Polygon Edge Documentation](https://docs.polygon.technology/docs/edge/overview/)**.

## Terraform deployment

This is a fully automated Polygon Edge blockchain infrastructure deployment for AWS cloud provider.

High level overview of the resources that will be deployed:
* Dedicated VPC
* 4 validator nodes (which are also boot nodes)
* 4 NAT gateways to allow nodes outbound internet traffic
* Lambda function used for generating the first (`genesis`) block and starting the chain
* Dedicated security groups and IAM roles
* S3 bucket used for storing `genesis.json` file
* Application Load Balancer used for exposing the `JSON-RPC` endpoint

### Prerequisites

Two variables that must be provided, before running the deployment:

* `alb_ssl_certificate` - the ARN of the certificate from AWS Certificate Manager to be used by ALB for https protocol.   
  The certificate must be generated before starting the deployment, and it must have **Issued** status.
* `premine` - the account/s that will receive pre mined native currency.
  Value must follow the official [CLI](https://docs.polygon.technology/docs/edge/get-started/cli-commands#genesis-flags) flag specification.

### Fault tolerance

Only regions that have 4 availability zones are required for this deployment. Each node is deployed in a single AZ.

By placing each node in a single AZ, the whole blockchain cluster is fault-tolerant to a single node (AZ) failure, as Polygon Edge implements IBFT
consensus which allows a single node to fail in a 4 validator node cluster.

### Command line access

Validator nodes are not exposed in any way to the public internet (JSON-PRC is accessed only via ALB)
and they don't even have public IP addresses attached to them.  
Nodes command line access is possible only via ***AWS Systems Manager - Session Manager***.

### Base AMI upgrade

This deployment uses `ubuntu-focal-20.04-amd64-server` AWS AMI. It will **not** trigger EC2 *redeployment* if the AWS AMI gets updated.

If, for some reason, base AMI is required to get updated,
it can be achieved by running `terraform taint` command for each instance, before `terraform apply`.   
Instances can be tainted by running the `terraform taint module.instances[<instance_number>].aws_instance.polygon_edge_instance` command.

Example:
```shell
terraform taint module.instances[0].aws_instance.polygon_edge_instance
terraform taint module.instances[1].aws_instance.polygon_edge_instance
terraform taint module.instances[2].aws_instance.polygon_edge_instance
terraform taint module.instances[3].aws_instance.polygon_edge_instance
terraform apply
```

### Resources cleanup

When cleaning up all resources by running `terraform destory`, the only thing that needs to be manually deleted
are **validator keys** from **AWS SSM Parameter Store** as they are not stored via Terraform, but with `polygon-edge`
process itself.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0, < 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.27.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 2.2.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.2.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >=3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_instances"></a> [instances](#module\_instances) | ./modules/instances | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | >=3.3.1 |
| <a name="module_s3"></a> [s3](#module\_s3) | terraform-aws-modules/s3-bucket/aws | >= 3.3.0 |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_user_data"></a> [user\_data](#module\_user\_data) | ./modules/user-data | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | aws-ia/vpc/aws | = 1.4.1 |

## Resources

| Name | Type |
|------|------|
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.genesis_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.genesis_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [null_data_source.downloaded_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ssl_certificate"></a> [alb\_ssl\_certificate](#input\_alb\_ssl\_certificate) | SSL certificate ARN for JSON-RPC loadblancer | `string` | n/a | yes |
| <a name="input_premine"></a> [premine](#input\_premine) | Premine the accounts with the specified ammount. Format: account:ammount,account:ammount | `string` | n/a | yes |
| <a name="input_alb_sec_gr_name_tag"></a> [alb\_sec\_gr\_name\_tag](#input\_alb\_sec\_gr\_name\_tag) | External security group name tag | `string` | `"Polygon Edge External"` | no |
| <a name="input_block_gas_limit"></a> [block\_gas\_limit](#input\_block\_gas\_limit) | Set the block gas limit | `string` | `""` | no |
| <a name="input_block_gas_target"></a> [block\_gas\_target](#input\_block\_gas\_target) | Sets the target block gas limit for the chain | `string` | `""` | no |
| <a name="input_block_time"></a> [block\_time](#input\_block\_time) | Set block production time in seconds | `string` | `""` | no |
| <a name="input_chain_data_ebs_name_tag"></a> [chain\_data\_ebs\_name\_tag](#input\_chain\_data\_ebs\_name\_tag) | The name of the chain data EBS volume. | `string` | `"Polygon_Edge_chain_data_volume"` | no |
| <a name="input_chain_data_ebs_volume_size"></a> [chain\_data\_ebs\_volume\_size](#input\_chain\_data\_ebs\_volume\_size) | The size of the chain data EBS volume. | `number` | `30` | no |
| <a name="input_chain_id"></a> [chain\_id](#input\_chain\_id) | Set the Chain ID | `string` | `""` | no |
| <a name="input_chain_name"></a> [chain\_name](#input\_chain\_name) | Set the name of chain | `string` | `""` | no |
| <a name="input_consensus"></a> [consensus](#input\_consensus) | Sets consensus protocol. | `string` | `""` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | Sets the DNS name for the network package | `string` | `""` | no |
| <a name="input_ebs_device"></a> [ebs\_device](#input\_ebs\_device) | The ebs device path. Defined when creating EBS volume. | `string` | `"/dev/nvme1n1"` | no |
| <a name="input_ebs_root_name_tag"></a> [ebs\_root\_name\_tag](#input\_ebs\_root\_name\_tag) | The name tag for the Polygon Edge instance root volume. | `string` | `"Polygon_Edge_Root_Volume"` | no |
| <a name="input_epoch_size"></a> [epoch\_size](#input\_epoch\_size) | Set the epoch size | `string` | `""` | no |
| <a name="input_instance_interface_name_tag"></a> [instance\_interface\_name\_tag](#input\_instance\_interface\_name\_tag) | The name of the instance interface. | `string` | `"Polygon_Edge_Instance_Interface"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of Polygon Edge instance | `string` | `"Polygon_Edge_Node"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Polygon Edge nodes instance type. | `string` | `"t3.medium"` | no |
| <a name="input_internal_sec_gr_name_tag"></a> [internal\_sec\_gr\_name\_tag](#input\_internal\_sec\_gr\_name\_tag) | Internal security group name tag | `string` | `"Polygon Edge Internal"` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | The name of the Lambda function used for chain init | `string` | `"polygon-edge-init"` | no |
| <a name="input_lambda_function_zip"></a> [lambda\_function\_zip](#input\_lambda\_function\_zip) | The lambda function code in zip archive | `string` | `"https://raw.githubusercontent.com/Trapesys/polygon-edge-assm/aws-lambda/artifacts/main.zip"` | no |
| <a name="input_max_slots"></a> [max\_slots](#input\_max\_slots) | Sets maximum slots in the pool | `string` | `""` | no |
| <a name="input_max_validator_count"></a> [max\_validator\_count](#input\_max\_validator\_count) | The maximum number of stakers able to join the validator set in a PoS consensus. | `string` | `""` | no |
| <a name="input_min_validator_count"></a> [min\_validator\_count](#input\_min\_validator\_count) | The minimum number of stakers needed to join the validator set in a PoS consensus. | `string` | `""` | no |
| <a name="input_nat_address"></a> [nat\_address](#input\_nat\_address) | Sets the NAT address for the networking package | `string` | `""` | no |
| <a name="input_node_name_prefix"></a> [node\_name\_prefix](#input\_node\_name\_prefix) | The name prefix that will be used to store secrets | `string` | `"node"` | no |
| <a name="input_nodes_alb_name_prefix"></a> [nodes\_alb\_name\_prefix](#input\_nodes\_alb\_name\_prefix) | ALB name | `string` | `"jrpc-"` | no |
| <a name="input_nodes_alb_name_tag"></a> [nodes\_alb\_name\_tag](#input\_nodes\_alb\_name\_tag) | ALB name tag | `string` | `"Polygon Edge JSON-RPC ALB"` | no |
| <a name="input_nodes_alb_targetgroup_name_prefix"></a> [nodes\_alb\_targetgroup\_name\_prefix](#input\_nodes\_alb\_targetgroup\_name\_prefix) | ALB target group name | `string` | `"jrpc-"` | no |
| <a name="input_polygon_edge_dir"></a> [polygon\_edge\_dir](#input\_polygon\_edge\_dir) | The directory to place all polygon-edge data and logs | `string` | `"/home/ubuntu/polygon"` | no |
| <a name="input_pos"></a> [pos](#input\_pos) | Use PoS IBFT consensus | `bool` | `false` | no |
| <a name="input_price_limit"></a> [price\_limit](#input\_price\_limit) | Sets minimum gas price limit to enforce for acceptance into the pool | `string` | `""` | no |
| <a name="input_prometheus_address"></a> [prometheus\_address](#input\_prometheus\_address) | Enable Prometheus API | `string` | `""` | no |
| <a name="input_s3_bucket_prefix"></a> [s3\_bucket\_prefix](#input\_s3\_bucket\_prefix) | Name prefix for new S3 bucket | `string` | `"polygon-edge-shared-"` | no |
| <a name="input_s3_force_destroy"></a> [s3\_force\_destroy](#input\_s3\_force\_destroy) | Delete S3 bucket on destroy, even if the bucket is not empty | `bool` | `true` | no |
| <a name="input_s3_key_name"></a> [s3\_key\_name](#input\_s3\_key\_name) | Name of the file in S3 that will hold configuration | `string` | `"chain-config"` | no |
| <a name="input_ssm_parameter_id"></a> [ssm\_parameter\_id](#input\_ssm\_parameter\_id) | The id that will be used for storing and fetching from SSM Parameter Store | `string` | `"polygon-edge-validators"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for VPC | `string` | `"10.250.0.0/16"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"polygon-edge-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jsonrpc_dns_name"></a> [jsonrpc\_dns\_name](#output\_jsonrpc\_dns\_name) | The dns name for the JSON-RPC API |
<!-- END_TF_DOCS -->
