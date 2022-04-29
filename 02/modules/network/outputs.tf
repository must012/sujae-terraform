output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet[*].id
}

output "rds_private_subnets_id" {
  value = aws_subnet.rds_private_subnet[*].id
}

output "endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}