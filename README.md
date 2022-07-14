<!-- BEGIN_TF_DOCS -->
# Creating modules for AWS I&A Organization

This repo template is used to seed Terraform Module templates for the [AWS I&A GitHub organization](https://github.com/aws-ia). Usage of this template is allowed per included license. PRs to this template will be considered but are not guaranteed to be included. Consider creating an issue to discuss a feature you want to include before taking the time to create a PR.
### TL;DR

1. [install pre-commit](https://pre-commit.com/)
2. configure pre-commit: `pre-commit install`
3. install required tools
    - [tflint](https://github.com/terraform-linters/tflint)
    - [tfsec](https://aquasecurity.github.io/tfsec/v1.0.11/)
    - [terraform-docs](https://github.com/terraform-docs/terraform-docs)
    - [golang](https://go.dev/doc/install) (for macos you can use `brew`)
    - [coreutils](https://www.gnu.org/software/coreutils/)

Write code according to [I&A module standards](https://aws-ia.github.io/standards-terraform/)

## Module Documentation

**Do not manually update README.md**. `terraform-docs` is used to generate README files. For any instructions an content, please update [.header.md](./.header.md) then simply run `terraform-docs ./` or allow the `pre-commit` to do so.

## Terratest

Please include tests to validate your examples/<> root modules, at a minimum. This can be accomplished with usually only slight modifications to the [boilerplate test provided in this template](./test/examples\_basic\_test.go)

### Configure and run Terratest

1. Install

    [golang](https://go.dev/doc/install) (for macos you can use `brew`)
2. Change directory into the test folder.
    
    `cd test`
3. Initialize your test
    
    go mod init github.com/[github org]/[repository]

    `go mod init github.com/aws-ia/terraform-aws-vpc`
4. Run tidy

    `git mod tidy`
5. Install Terratest

    `go get github.com/gruntwork-io/terratest/modules/terraform`
6. Run test (You can have multiple test files).
    - Run all tests

        `go test`
    - Run a specific test with a timeout

        `go test -run examples_basic_test.go -timeout 45m`
## Module Standards

For best practices and information on developing with Terraform, see the [I&A Module Standards](https://aws-ia.github.io/standards-terraform/)

## Continuous Integration

The I&A team uses AWS CodeBuild to perform continuous integration (CI) within the organization. Our CI uses the a repo's `.pre-commit-config.yaml` file as well as some other checks. All PRs with other CI will be rejected. See our [FAQ](https://aws-ia.github.io/standards-terraform/faq/#are-modules-protected-by-ci-automation) for more details.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.27.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_instances"></a> [instances](#module\_instances) | ./modules/instances | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | terraform-aws-modules/s3-bucket/aws | >= 3.3.0 |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_user_data"></a> [user\_data](#module\_user\_data) | ./modules/user-data | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | aws-ia/vpc/aws | >= 1.4.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS account number | `string` | n/a | yes |
| <a name="input_alb_ssl_certificate"></a> [alb\_ssl\_certificate](#input\_alb\_ssl\_certificate) | SSL certificate ARN for JSON-RPC loadblancer | `string` | n/a | yes |
| <a name="input_alb_sec_gr_name_tag"></a> [alb\_sec\_gr\_name\_tag](#input\_alb\_sec\_gr\_name\_tag) | External security group name tag | `string` | `"Polygon Edge External"` | no |
| <a name="input_block_gas_target"></a> [block\_gas\_target](#input\_block\_gas\_target) | Sets the target block gas limit for the chain | `string` | `""` | no |
| <a name="input_block_time"></a> [block\_time](#input\_block\_time) | Set block production time in seconds | `string` | `""` | no |
| <a name="input_chain_data_ebs_name_tag"></a> [chain\_data\_ebs\_name\_tag](#input\_chain\_data\_ebs\_name\_tag) | The name of the chain data EBS volume. | `string` | `"Polygon_Edge_chain_data_volume"` | no |
| <a name="input_chain_data_ebs_volume_size"></a> [chain\_data\_ebs\_volume\_size](#input\_chain\_data\_ebs\_volume\_size) | The size of the chain data EBS volume. | `number` | `30` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | Sets the DNS name for the network package | `string` | `""` | no |
| <a name="input_ebs_device"></a> [ebs\_device](#input\_ebs\_device) | The ebs device path. Defined when creating EBS volume. | `string` | `"/dev/nvme1n1"` | no |
| <a name="input_ebs_root_name_tag"></a> [ebs\_root\_name\_tag](#input\_ebs\_root\_name\_tag) | The name tag for the Polygon Edge instance root volume. | `string` | `"Polygon_Edge_Root_Volume"` | no |
| <a name="input_instance_interface_name_tag"></a> [instance\_interface\_name\_tag](#input\_instance\_interface\_name\_tag) | The name of the instance interface. | `string` | `"Polygon_Edge_Instance_Interface"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of Polygon Edge instance | `string` | `"Polygon_Edge_Node"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Polygon Edge nodes instance type. | `string` | `"t3.medium"` | no |
| <a name="input_internal_sec_gr_name_tag"></a> [internal\_sec\_gr\_name\_tag](#input\_internal\_sec\_gr\_name\_tag) | Internal security group name tag | `string` | `"Polygon Edge Internal"` | no |
| <a name="input_max_slots"></a> [max\_slots](#input\_max\_slots) | Sets maximum slots in the pool | `string` | `""` | no |
| <a name="input_nat_address"></a> [nat\_address](#input\_nat\_address) | Sets the NAT address for the networking package | `string` | `""` | no |
| <a name="input_node_name_prefix"></a> [node\_name\_prefix](#input\_node\_name\_prefix) | The name prefix that will be used to store secrets | `string` | `"node"` | no |
| <a name="input_nodes_alb_name_prefix"></a> [nodes\_alb\_name\_prefix](#input\_nodes\_alb\_name\_prefix) | ALB name | `string` | `"jrpc-"` | no |
| <a name="input_nodes_alb_name_tag"></a> [nodes\_alb\_name\_tag](#input\_nodes\_alb\_name\_tag) | ALB name tag | `string` | `"Polygon Edge JSON-RPC ALB"` | no |
| <a name="input_nodes_alb_targetgroup_name_prefix"></a> [nodes\_alb\_targetgroup\_name\_prefix](#input\_nodes\_alb\_targetgroup\_name\_prefix) | ALB target group name | `string` | `"jrpc-"` | no |
| <a name="input_polygon_edge_dir"></a> [polygon\_edge\_dir](#input\_polygon\_edge\_dir) | The directory to place all polygon-edge data and logs | `string` | `"/home/ubuntu/polygon"` | no |
| <a name="input_price_limit"></a> [price\_limit](#input\_price\_limit) | Sets minimum gas price limit to enforce for acceptance into the pool | `string` | `""` | no |
| <a name="input_prometheus_address"></a> [prometheus\_address](#input\_prometheus\_address) | Enable Prometheus API | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-west-2"` | no |
| <a name="input_s3_bucket_prefix"></a> [s3\_bucket\_prefix](#input\_s3\_bucket\_prefix) | Name prefix for new S3 bucket | `string` | `"polygon-edge-shared-"` | no |
| <a name="input_ssm_parameter_id"></a> [ssm\_parameter\_id](#input\_ssm\_parameter\_id) | The id that will be used for storing and fetching from SSM Parameter Store | `string` | `"polygon-edge-validators"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for VPC | `string` | `"10.250.0.0/16"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"polygon-edge-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jsonrpc_dns_name"></a> [jsonrpc\_dns\_name](#output\_jsonrpc\_dns\_name) | The dns name for the JSON-RPC API |
<!-- END_TF_DOCS -->