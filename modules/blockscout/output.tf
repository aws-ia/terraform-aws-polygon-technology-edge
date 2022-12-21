output "sg_internal_id" {
  value = module.sg_internal.security_group_id
}

output "sg_lb_id" {
  value = module.sg_lb.security_group_id
}

output "instance_id" {
  value = module.ec2_instance.id
}