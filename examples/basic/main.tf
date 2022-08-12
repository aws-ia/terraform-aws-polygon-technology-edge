module "polygon-edge" {
  source  = "aws-ia/polygon-technology-edge/aws"
  version = "0.0.1"

  account_id          = var.account_id
  premine             = var.premine
  alb_ssl_certificate = var.alb_ssl_certificate
}