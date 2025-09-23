output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}

output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

output "web_tg_arn" {
  value = aws_lb_target_group.web_tg.arn
}

output "app_tg_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "public_alb_sg_id" {
  value = aws_security_group.alb_public_sg.id
}

output "internal_alb_sg_id" {
  value = aws_security_group.alb_internal_sg.id
}
