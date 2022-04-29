output "private_ec2_sg_id" {
  value = aws_security_group.private_ec2_sg_1.id
}

output "private_rds_sg_id" {
  value = aws_security_group.private_rds_sg_1.id
}

output "public_sg_id" {
  value = aws_security_group.public_sg_1.id
}
