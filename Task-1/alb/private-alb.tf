resource "aws_lb" "internal" {
  name                                  = "${var.project}-aps-${var.env}-internal"
  internal                              = true
  load_balancer_type                    = "application"
  security_groups                       = [aws_security_group.alb_internal_sg.id]
  subnets                               = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  enable_deletion_protection            = false

  tags = {
    Name                                = "${var.project}-aps-${var.env}-internal"
    environment                         = var.env
  }
}

resource "aws_security_group" "alb_internal_sg" {
  name                                  = "alb_internal_sg_${var.env}"
  description                           = "alb_internal_sg_${var.env}"
  vpc_id                                = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description                         = "Allow HTTP from Web SG"
    from_port                           = 80
    to_port                             = 80
    protocol                            = "tcp"
    #security_groups                     = [data.terraform_remote_state.app.outputs.web_sg_id]
    cidr_blocks                         = ["0.0.0.0/0"]
  }

  egress {
    from_port                           = 0
    to_port                             = 0
    protocol                            = "-1"
    cidr_blocks                         = ["0.0.0.0/0"]
  }

  tags                                  = {
    Name                                = "alb_internal_sg_${var.env}"
    environment                         = var.env
  }
}


resource "aws_lb_target_group" "app_tg" {
  name        = "${var.project}-aps-${var.env}-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "instance" # or "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_listener_rule" "app_rule" {
  listener_arn = aws_lb_listener.app_http.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  condition {
    path_pattern {
      values = ["/app/*"]
    }
  }
}
