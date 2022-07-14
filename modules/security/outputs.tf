output "internal_sec_group_id" {
  value       = aws_security_group.polygon_internal.id
  description = "Internal security group. Should be attached to Polygon Edge nodes only."
}

output "jsonrpc_sec_group_id" {
  value       = aws_security_group.json_rpc_alb.id
  description = "Jsonrpc instance security group. Should be attached to ALB"
}

output "ec2_to_assm_iam_policy_id" {
  value       = aws_iam_instance_profile.polygon_edge_node.id
  description = "IAM policy that allows communication between EC2 and ASSM"
}