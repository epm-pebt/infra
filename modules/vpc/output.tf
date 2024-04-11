output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.Back_public-subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.Back_private-subnet[*].id
}