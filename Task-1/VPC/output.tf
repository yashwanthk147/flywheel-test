output "public_subnet_keys" {
  value = [for k, v in var.public_subnets : k]
}


output "nat_gateway_ids" {
  value = {
    for k, ngw in aws_nat_gateway.nat_gateway :
    k => ngw.id
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public_subnets : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private_subnets : s.id]
}
