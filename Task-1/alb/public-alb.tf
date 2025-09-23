resource "aws_lb" "public" {
  name                                  = "${var.project}-aps-${var.env}-public"
  internal                              = var.IS_PUBLIC_INTERNAL
  load_balancer_type                    = "application"
  security_groups                       = [aws_security_group.alb_public_sg.id]
  subnets                               = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  enable_deletion_protection            = false

  tags = {
    Name                                = "${var.project}-aps-${var.env}-public"
    environment                         = var.env
  }
}

resource "aws_security_group" "alb_public_sg" {
  name                                  = "alb_public_sg_${var.env}"
  description                           = "alb_public_sg_${var.env}"
  vpc_id                                = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description                         = "HTTP"
    from_port                           = 80
    to_port                             = 80
    protocol                            = "tcp"
    cidr_blocks                         = ["0.0.0.0/0"]
  }

  egress {
    from_port                           = 0
    to_port                             = 0
    protocol                            = "-1"
    cidr_blocks                         = ["0.0.0.0/0"]
  }

  tags                                  = {
    Name                                = "alb_public_sg_${var.env}"
    environment                         = var.env
  }
}


resource "aws_lb_target_group" "web_tg" {
  name        = "${var.project}-aps-${var.env}-web-tg"
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

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_lb_listener.web_http.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
