output "vpc_id" {
  value = aws_vpc.music-app.id
}

output "vpc_cidr" {
  value = aws_vpc.music-app.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.Back_public-subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.Back_private-subnet[*].id
}