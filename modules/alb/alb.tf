// Create new ALB
resource "aws_lb" "polygon-nodes" {
  name               = var.nodes_alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in var.public_subnets : subnet.id]
  security_groups = [var.alb_sec_group]
  

  tags = {
    Name = var.nodes_alb_name_tag
  }
}
// Create new ALB Target Group
resource "aws_lb_target_group" "polygon-nodes" {
  name     = var.nodes_nlb_targetgroup_name
  port     = var.nodes_nlb_targetgroup_port
  protocol = var.nodes_nlb_targetgroup_proto
  vpc_id   = var.vpc_id
}

// Set listener on ALB
resource "aws_lb_listener" "polygon-nodes" {
  load_balancer_arn = aws_lb.polygon-nodes.arn
  port              = var.nodes_nlb_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.polygon-nodes.arn
  }
}

// Attach instances to ALB
resource "aws_lb_target_group_attachment" "polygon-nodes" {
  count = length(var.node_ids)

  target_group_arn = aws_lb_target_group.polygon-nodes.arn
  target_id        = var.node_ids[count.index]
  port             = var.nodes_nlb_targetgroup_port
}
