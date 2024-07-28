resource "aws_lb" "test" {
    for_each = var.alb
    name_prefix = "3tier"
  internal           = false
  load_balancer_type = "application"
  security_groups    = each.value["sg-id"]
  subnets            = each.value["subnet-id"]

  tags = {
    Name  = "my-alb"
  }
}
 
 resource "aws_lb_target_group" "tg" {
  for_each = var.tg
  name_prefix = "alb-tg"
  port     = each.value["port"]
  protocol = each.value["protcol"]
  vpc_id   = var.vpc-id
  health_check {
    matcher = "200-399"
  }
 }

  resource "aws_lb_listener" "listner-1" {
  load_balancer_arn = var.arn
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = var.tg-arn
 }
 
}
