output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet1_id" {
  description = "ID of public subnet 1"
  value       = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  description = "ID of public subnet 2"
  value       = aws_subnet.public_subnet2.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.gw.id
}