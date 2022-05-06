resource "aws_alb" "alb" {
  name                             = "${var.env}-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [var.public_sg_id]
  subnets                          = var.public_subnets_id
  enable_cross_zone_load_balancing = true

  tags = {
    "Name" = "${var.env}-alb"
  }
}

resource "aws_alb_target_group" "alb_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_target_group_attachment" "privateInstance01" {
  count            = var.ec2_count
  target_group_arn = aws_alb_target_group.alb_tg.arn
  target_id        = var.ec2_id[count.index]
  port             = 80
}

resource "aws_alb_listener" "alb_lis" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }
}