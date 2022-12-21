output "sg_internal_id" {
  value       = module.sg_internal.security_group_id
  description = "ID of SG which attached to blockscout ec2-instance"
}

output "sg_lb_id" {
  value       = module.sg_lb.security_group_id
  description = "ID of SG which attached to lb"
}

output "instance_id" {
  value       = module.ec2_instance.id
  description = "ID of ec2-instance"
}