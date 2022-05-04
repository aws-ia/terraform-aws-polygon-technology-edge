output "internal_sec_group_id" {
  value = aws_security_group.polygon_internal.id
  description = "Internal security group. Should be attached to Polygon Edge nodes only."
}

output "bastion_public_id" {
  value = aws_security_group.bastion_public.id
  description = "Bastion instance security group. Should be attached to Bastion instance only."
}

output "jsonrpc_sec_group_id" {
  value = aws_security_group.json_rpc_alb.id
  description = "Jsonrpc instance security group. Should be attached to ALB"
}

output "ec2_to_assm_iam_policy_id" {
  value = aws_iam_instance_profile.ec2_to_assm.id
  description = "IAM policy that allows communication between EC2 and ASSM"
}

output "ssh_key_name" {
  value = aws_key_pair.bastion_ssh.key_name
  description = "SSH key name used to authenticate to Bastion instance"
}