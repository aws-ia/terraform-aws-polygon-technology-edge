<!-- BEGIN_TF_DOCS -->
# Polygon Edge simple deployment on AWS

## Prerequisites

Three variables that must be provided, before running the deployment:

* `account_id` - the AWS account ID that the Polygon Edge blockchain cluster will be deployed on.
* `alb_ssl_certificate` - the ARN of the certificate from AWS Certificate Manager to be used by ALB for https protocol.   
  The certificate must be generated before starting the deployment, and it must have **Issued** status.
* `premine` - the account/s that will receive pre mined native currency.
  Value must follow the official [CLI](https://docs.polygon.technology/docs/edge/get-started/cli-commands#genesis-flags) flag specification.

## Deployment
To get Polygon Edge cluster quickly up and running default values:
* include this module
* define mandatory variables or provide them at cli prompt    
* `terraform init` - to initialize modules   
* `terraform apply` - to deploy the infrastructure

After everything is deployed the JSON-RPC URL should be outputted in the CLI, which needs to be set as a CNAME target
for a domain that you've created the certificate for.

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_polygon-edge"></a> [polygon-edge](#module\_polygon-edge) | aws-ia/polygon-technology-edge/aws | >=0.0.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ssl_certificate"></a> [alb\_ssl\_certificate](#input\_alb\_ssl\_certificate) | The ARN of SSL certificate that will be placed on JSON-RPC ALB | `string` | n/a | yes |
| <a name="input_premine"></a> [premine](#input\_premine) | Public account that will receive premined native currency | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_json_rpc_dns_name"></a> [json\_rpc\_dns\_name](#output\_json\_rpc\_dns\_name) | The dns name for the JSON-RPC API |
<!-- END_TF_DOCS -->