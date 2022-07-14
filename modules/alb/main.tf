# Create new ALB
resource "aws_lb" "polygon_nodes" {
  name_prefix = var.nodes_alb_name_prefix
  #tfsec:ignore:aws-elb-alb-not-public
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.public_subnets
  security_groups            = [var.alb_sec_group]
  drop_invalid_header_fields = true


  tags = {
    Name = var.nodes_alb_name_tag
  }
}
# Create new ALB Target Group
resource "aws_lb_target_group" "polygon_nodes" {
  name_prefix = var.nodes_alb_targetgroup_name_prefix
  port        = 8545
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

# Set http listener on ALB
resource "aws_lb_listener" "polygon_nodes_http" {
  load_balancer_arn = aws_lb.polygon_nodes.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      status_code = "HTTP_301"
      port        = 443
      protocol    = "HTTPS"
    }
  }
}

# Set https listener on ALB
resource "aws_lb_listener" "polygon_nodes_https" {
  load_balancer_arn = aws_lb.polygon_nodes.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.alb_ssl_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.polygon_nodes.arn
  }
}

# Attach instances to ALB
resource "aws_lb_target_group_attachment" "polygon_nodes" {
  count = length(var.node_ids)

  target_group_arn = aws_lb_target_group.polygon_nodes.arn
  target_id        = var.node_ids[count.index]
  port             = 8545
}
