output "vpc_id" {
  value = aws_vpc.vpc1dev.id
}

output "public_subnets" {
  value = [
    aws_subnet.public1_dev.id,
    aws_subnet.public2_dev.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private1_dev.id,
    aws_subnet.private2_dev.id
  ]
}

output "public_subnet_1_id" {
  value = aws_subnet.public1_dev.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private1_dev.id
}

