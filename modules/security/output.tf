output "internal_sec_group_id" {
  value = aws_security_group.polygon_internal.id
  description = "Internal security group. Should be attached to Polygon Edge nodes only."
}

output "bastion_public_id" {
  value = aws_security_group.bastion_public.id
  description = "Bastion instance security group. Should be attached to Bastion instance only."
}

output "ec2_to_assm_iam_policy_id" {
  value = aws_iam_instance_profile.ec2_to_assm.id
  description = "IAM policy that allows communication between EC2 and ASSM"
}